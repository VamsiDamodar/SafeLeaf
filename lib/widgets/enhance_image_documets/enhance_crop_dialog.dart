import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/utils/app_textstyles.dart';



class EnhanceCropDialog extends StatefulWidget {
  final File file;
  final int rotationTurns;

  const EnhanceCropDialog({
    super.key,
    required this.file,
    required this.rotationTurns,
  });

  @override
  State<EnhanceCropDialog> createState() => _EnhanceCropDialogState();
}

class _EnhanceCropDialogState extends State<EnhanceCropDialog> {
  final _previewKey = GlobalKey();

  ui.Image? _image;
  Rect? _imageRect;
  List<Offset>? _cropPoints;
  int? _dragPointIndex;
  bool _isMovingSelection = false;
  Offset _lastDragPosition = Offset.zero;
  bool _isApplying = false;
  bool _isCropInvalid = false;

  static const _hitSize = 28.0;
  // Crop validation rules.
  // Tiny crops, crossed corners, and extreme skew shapes ni block chestham.
  // Crop validation rules.
  // Small crops, crossed corners, and extreme skew shapes ni block chestham.
  static const _minCropSideRatio = .22;
  static const _minCropAreaRatio = .20;
  static const _maxSideRatio = 3.0;
  static const _minCornerAngleDegrees = 35.0;
  static const _maxCornerAngleDegrees = 145.0;
  

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void dispose() {
    _image?.dispose();
    super.dispose();
  }

  Future<void> _loadImage() async {
    final bytes = await widget.file.readAsBytes();
    final source = await _decodeImage(bytes);
    final rotated = await _rotateImageIfNeeded(source, widget.rotationTurns);
    source.dispose();

    if (!mounted) {
      rotated.dispose();
      return;
    }

    setState(() => _image = rotated);
  }

  @override
  Widget build(BuildContext context) {
    final image = _image;
    final size = MediaQuery.sizeOf(context);
    final canApplyCrop = image != null && !_isApplying && !_isCropInvalid && _isCropValid(_cropPoints, _imageRect);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 560,
          maxHeight: size.height * .86,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Advanced crop',
                      style: AppTextStyles.drawerItem.copyWith(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Reset crop',
                    onPressed: image == null || _isApplying ? null : _resetCrop,
                    icon: const Icon(Icons.refresh_rounded),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: _isApplying ? null : () => Get.back(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              AspectRatio(
                aspectRatio: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: image == null
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          )
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              _syncRectsForSize(
                                Size(
                                  constraints.maxWidth,
                                  constraints.maxHeight,
                                ),
                                image,
                              );

                              return Padding(
                                padding: const EdgeInsets.all(12),
                                child: GestureDetector(
                                  key: _previewKey,
                                  onPanStart: _onPanStart,
                                  onPanUpdate: _onPanUpdate,
                                  onPanEnd: (_) {
                                    _dragPointIndex = null;
                                    _isMovingSelection = false;
                                  },
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      CustomPaint(
                                        painter: _CropImagePainter(image: image),
                                      ),
                                      CustomPaint(
                                        painter:_CropOverlayPainter(
                                          image: image,
                                          imageRect: _imageRect!,
                                          cropPoints: _cropPoints!,
                                          isInvalid: _isCropInvalid,
                                          magnifierPoint: _dragPointIndex == null
                                              ? null
                                              : _cropPoints![_dragPointIndex!],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isApplying ? null : () => Get.back(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: canApplyCrop ? _applyCrop : null,
                      child: _isApplying
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _syncRectsForSize(Size canvasSize, ui.Image image) {
    final fitted = applyBoxFit(
      BoxFit.contain,
      Size(image.width.toDouble(), image.height.toDouble()),
      canvasSize,
    );
    final destination = Alignment.center.inscribe(
      fitted.destination,
      Offset.zero & canvasSize,
    );

    if (_imageRect == destination && _cropPoints != null) return;
    _imageRect = destination;
    _cropPoints = _defaultCropPoints(destination);
  }

  void _onPanStart(DragStartDetails details) {
    final local = _toLocal(details.globalPosition);
    final points = _cropPoints;
    if (local == null || points == null) return;

    _lastDragPosition = local;
    _dragPointIndex = _hitCorner(local, points);
    _isMovingSelection =
        _dragPointIndex == null && _cropPath(points).contains(local);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final points = _cropPoints;
    final imageRect = _imageRect;
    if (points == null ||
        imageRect == null ||
        (_dragPointIndex == null && !_isMovingSelection)) {
      return;
    }

    final local = _toLocal(details.globalPosition);
    if (local == null) return;

    final delta = local - _lastDragPosition;
    _lastDragPosition = local;

    final updatedPoints = _updatedCropPoints(
      points,
      delta,
      imageRect,
      pointIndex: _dragPointIndex,
      moveSelection: _isMovingSelection,
    );

    // Invalid shapes ni UI lone stop chestham:
    // crossed corners, too-small crops, and extreme skew crops.
    // Invalid shape aina UI lo chupistham, kani Apply disable chestham.
    setState(() {
      _cropPoints = updatedPoints;
      _isCropInvalid = !_isCropValid(updatedPoints, imageRect);
    });
  }

  Offset? _toLocal(Offset globalPosition) {
    final box = _previewKey.currentContext?.findRenderObject() as RenderBox?;
    return box?.globalToLocal(globalPosition);
  }
  List<Offset> _defaultCropPoints(Rect imageRect) {
    // Default crop image edges ki konchem padding tho start avuthundi.
    final inset = imageRect.shortestSide * .08;
    final initialRect = imageRect.deflate(inset);

    return [
      initialRect.topLeft,
      initialRect.topRight,
      initialRect.bottomRight,
      initialRect.bottomLeft,
    ];
  }

  void _resetCrop() {
    final imageRect = _imageRect;
    if (imageRect == null) return;

    setState(() {
      _cropPoints = _defaultCropPoints(imageRect);
      _isCropInvalid = false;
    });
  }
  bool _hasValidCornerAngles(List<Offset> points) {
    for (var i = 0; i < points.length; i++) {
      final previous = points[(i - 1 + points.length) % points.length];
      final current = points[i];
      final next = points[(i + 1) % points.length];

      final angle = _angleBetween(previous - current, next - current);

      if (angle < _minCornerAngleDegrees ||
          angle > _maxCornerAngleDegrees) {
        return false;
      }
    }

    return true;
  }

  double _angleBetween(Offset first, Offset second) {
    final dot = first.dx * second.dx + first.dy * second.dy;
    final firstLength = first.distance;
    final secondLength = second.distance;

    if (firstLength == 0 || secondLength == 0) return 0;

    final cosine = (dot / (firstLength * secondLength)).clamp(-1.0, 1.0);
    return math.acos(cosine) * 180 / math.pi;
  }

  bool _isConvexQuadrilateral(List<Offset> points) {
    // 4 corners same direction lo turn avvali.
    // Crossed / twisted crop shapes ikkada invalid avuthayi.
    var hasPositive = false;
    var hasNegative = false;

    for (var i = 0; i < points.length; i++) {
      final a = points[i];
      final b = points[(i + 1) % points.length];
      final c = points[(i + 2) % points.length];
      final cross = _crossProduct(a, b, c);

      if (cross > 0) hasPositive = true;
      if (cross < 0) hasNegative = true;

      if (hasPositive && hasNegative) return false;
    }

    return true;
  }
  bool _isCropValid(List<Offset>? points, Rect? imageRect) {
    if (points == null || points.length != 4 || imageRect == null) return false;

    // Rule 1: Anni points image boundary lopale undali.
    for (final point in points) {
      if (!imageRect.contains(point)) return false;
    }

    // Rule 2: Shape convex ga undali. Corners cross ayithe invalid.
    if (!_isConvexQuadrilateral(points)) return false;

    // Rule 3: Corners too sharp / too wide avvakudadhu.
    if (!_hasValidCornerAngles(points)) return false;

    final top = (points[1] - points[0]).distance;
    final right = (points[2] - points[1]).distance;
    final bottom = (points[2] - points[3]).distance;
    final left = (points[3] - points[0]).distance;

    // Rule 4: Any side too small avvakudadhu.
    final minSide = imageRect.shortestSide * _minCropSideRatio;
    if (top < minSide || right < minSide || bottom < minSide || left < minSide) {
      return false;
    }

    // Rule 5: Crop area image area lo minimum percentage undali.
    final cropArea = _polygonArea(points);
    final imageArea = imageRect.width * imageRect.height;
    if (cropArea < imageArea * _minCropAreaRatio) return false;

    // Rule 6: Extreme skew avoid cheyyali.
    if (!_isSideRatioValid(top, bottom)) return false;
    if (!_isSideRatioValid(left, right)) return false;

    return true;
  }

    bool _isSideRatioValid(double first, double second) {
      final smaller = math.min(first, second);
      final larger = math.max(first, second);

      if (smaller <= 0) return false;
      return larger / smaller <= _maxSideRatio;
    }

    double _polygonArea(List<Offset> points) {
      var sum = 0.0;

      for (var i = 0; i < points.length; i++) {
        final current = points[i];
        final next = points[(i + 1) % points.length];
        sum += current.dx * next.dy - next.dx * current.dy;
      }

      return sum.abs() / 2;
    }

    double _crossProduct(Offset a, Offset b, Offset c) {
      return (b.dx - a.dx) * (c.dy - a.dy) -
          (b.dy - a.dy) * (c.dx - a.dx);
    }
    int? _hitCorner(Offset point, List<Offset> points) {
      for (var i = 0; i < points.length; i++) {
        if ((point - points[i]).distance <= _hitSize) return i;
      }
      return null;
    }

  List<Offset> _updatedCropPoints(
    List<Offset> points,
    Offset delta,
    Rect bounds, {
    required int? pointIndex,
    required bool moveSelection,
  }) {
    if (moveSelection) {
      final selectionBounds = _boundsForPoints(points);
      final allowedDx = delta.dx
          .clamp(
            bounds.left - selectionBounds.left,
            bounds.right - selectionBounds.right,
          )
          .toDouble();
      final allowedDy = delta.dy
          .clamp(
            bounds.top - selectionBounds.top,
            bounds.bottom - selectionBounds.bottom,
          )
          .toDouble();
      final allowedDelta = Offset(allowedDx, allowedDy);
      return points.map((point) => point + allowedDelta).toList();
    }

    if (pointIndex == null) return points;

    final updated = List<Offset>.from(points);
    final nextPoint = updated[pointIndex] + delta;
    updated[pointIndex] = Offset(
      nextPoint.dx.clamp(bounds.left, bounds.right).toDouble(),
      nextPoint.dy.clamp(bounds.top, bounds.bottom).toDouble(),
    );
    return updated;
  }

  Future<void> _applyCrop() async {
    final image = _image;
    final imageRect = _imageRect;
    final cropPoints = _cropPoints;
    if (image == null || imageRect == null || cropPoints == null) return;

    setState(() => _isApplying = true);

    final scaleX = image.width / imageRect.width;
    final scaleY = image.height / imageRect.height;
    final sourcePoints = cropPoints.map((point) {
      return Offset(
        (point.dx - imageRect.left) * scaleX,
        (point.dy - imageRect.top) * scaleY,
      );
    }).toList();

    final bytes = await _cropImage(image, sourcePoints);
    if (mounted) Get.back(result: bytes);
  }

  Path _cropPath(List<Offset> points) {
    return Path()
      ..moveTo(points[0].dx, points[0].dy)
      ..lineTo(points[1].dx, points[1].dy)
      ..lineTo(points[2].dx, points[2].dy)
      ..lineTo(points[3].dx, points[3].dy)
      ..close();
  }

  Rect _boundsForPoints(List<Offset> points) {
    var left = points.first.dx;
    var top = points.first.dy;
    var right = points.first.dx;
    var bottom = points.first.dy;

    for (final point in points.skip(1)) {
      left = math.min(left, point.dx);
      top = math.min(top, point.dy);
      right = math.max(right, point.dx);
      bottom = math.max(bottom, point.dy);
    }

    return Rect.fromLTRB(left, top, right, bottom);
  }

  Future<ui.Image> _decodeImage(Uint8List bytes) {
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(bytes, completer.complete);
    return completer.future;
  }

  Future<ui.Image> _rotateImageIfNeeded(ui.Image image, int turns) async {
    final normalizedTurns = turns % 4;
    if (normalizedTurns == 0) {
      return _cloneImage(image);
    }

    final swapsSize = normalizedTurns.isOdd;
    final width = swapsSize ? image.height.toDouble() : image.width.toDouble();
    final height = swapsSize ? image.width.toDouble() : image.height.toDouble();
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    canvas.translate(width / 2, height / 2);
    canvas.rotate(normalizedTurns * math.pi / 2);
    canvas.translate(-image.width / 2, -image.height / 2);
    canvas.drawImage(image, Offset.zero, Paint());

    final picture = recorder.endRecording();
    final rotated = await picture.toImage(width.round(), height.round());
    picture.dispose();
    return rotated;
  }

  Future<ui.Image> _cloneImage(ui.Image image) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawImage(image, Offset.zero, Paint());
    final picture = recorder.endRecording();
    final clone = await picture.toImage(image.width, image.height);
    picture.dispose();
    return clone;
  }

  Future<Uint8List> _cropImage(
      ui.Image image, List<Offset> sourcePoints) async {
    final sourceBounds = _boundsForPoints(sourcePoints);
    final outputWidth =
        sourceBounds.width.round().clamp(1, image.width).toInt();
    final outputHeight =
        sourceBounds.height.round().clamp(1, image.height).toInt();
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final clippedPath = Path()
      ..moveTo(
        sourcePoints[0].dx - sourceBounds.left,
        sourcePoints[0].dy - sourceBounds.top,
      )
      ..lineTo(
        sourcePoints[1].dx - sourceBounds.left,
        sourcePoints[1].dy - sourceBounds.top,
      )
      ..lineTo(
        sourcePoints[2].dx - sourceBounds.left,
        sourcePoints[2].dy - sourceBounds.top,
      )
      ..lineTo(
        sourcePoints[3].dx - sourceBounds.left,
        sourcePoints[3].dy - sourceBounds.top,
      )
      ..close();

    canvas.clipPath(clippedPath);
    canvas.drawImageRect(
      image,
      sourceBounds,
      Rect.fromLTWH(
        0,
        0,
        outputWidth.toDouble(),
        outputHeight.toDouble(),
      ),
      Paint(),
    );

    final picture = recorder.endRecording();
    final cropped = await picture.toImage(outputWidth, outputHeight);
    final data = await cropped.toByteData(format: ui.ImageByteFormat.png);
    picture.dispose();
    cropped.dispose();

    return data!.buffer.asUint8List();
  }
}

class _CropImagePainter extends CustomPainter {
  final ui.Image image;

  const _CropImagePainter({required this.image});

  @override
  void paint(Canvas canvas, Size size) {
    final fitted = applyBoxFit(
      BoxFit.contain,
      Size(image.width.toDouble(), image.height.toDouble()),
      size,
    );
    final destination = Alignment.center.inscribe(
      fitted.destination,
      Offset.zero & size,
    );

    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      destination,
      Paint(),
    );
  }

  @override
  bool shouldRepaint(covariant _CropImagePainter oldDelegate) {
    return oldDelegate.image != image;
  }
}

class _CropOverlayPainter extends CustomPainter {
  final ui.Image image;
  final Rect imageRect;
  final List<Offset> cropPoints;
  final bool isInvalid;
  final Offset? magnifierPoint;

  const _CropOverlayPainter({
    required this.image,
    required this.imageRect,
    required this.cropPoints,
    required this.isInvalid,
    required this.magnifierPoint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()..color = Colors.black.withOpacity(.48);
    final borderPaint = Paint()
      ..color = isInvalid ? Colors.red : Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final fullPath = Path()..addRect(Offset.zero & size);
    final cropPath = _cropPath();
    canvas.drawPath(
      Path.combine(PathOperation.difference, fullPath, cropPath),
      overlayPaint,
    );

    canvas.drawPath(cropPath, borderPaint);
    _drawGrid(canvas);
    _drawCorners(canvas);

    final point = magnifierPoint;
    if (point != null) {
    _drawMagnifier(canvas, size, point);
    }
    
  }

  Path _cropPath() {
    return Path()
      ..moveTo(cropPoints[0].dx, cropPoints[0].dy)
      ..lineTo(cropPoints[1].dx, cropPoints[1].dy)
      ..lineTo(cropPoints[2].dx, cropPoints[2].dy)
      ..lineTo(cropPoints[3].dx, cropPoints[3].dy)
      ..close();
  }

  void _drawGrid(Canvas canvas) {
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(.62)
      ..strokeWidth = 1;

    for (var i = 1; i <= 2; i++) {
      final t = i / 3;
      final topPoint = Offset.lerp(cropPoints[0], cropPoints[1], t)!;
      final bottomPoint = Offset.lerp(cropPoints[3], cropPoints[2], t)!;
      canvas.drawLine(topPoint, bottomPoint, gridPaint);

      final leftPoint = Offset.lerp(cropPoints[0], cropPoints[3], t)!;
      final rightPoint = Offset.lerp(cropPoints[1], cropPoints[2], t)!;
      canvas.drawLine(leftPoint, rightPoint, gridPaint);
    }
  }

  void _drawCorners(Canvas canvas) {
    for (final point in cropPoints) {
      canvas.drawCircle(point, 10, Paint()..color = AppColors.primary);
      canvas.drawCircle(point, 5, Paint()..color = Colors.white);
    }
  }
  void _drawMagnifier(Canvas canvas, Size size, Offset point) {
  const loupeSize = 96.0;
  const zoom = 2.4;
  const gap = 18.0;

  // Finger cover avvakunda point ki opposite side lo bubble chupistham.
  final showOnRight = point.dx < size.width / 2;
  final showBelow = point.dy < loupeSize + gap;

  final left = showOnRight
      ? math.min(point.dx + gap, size.width - loupeSize - 8)
      : math.max(point.dx - loupeSize - gap, 8.0);

  final top = showBelow
      ? math.min(point.dy + gap, size.height - loupeSize - 8)
      : math.max(point.dy - loupeSize - gap, 8.0);

  final loupeRect = Rect.fromLTWH(left, top, loupeSize, loupeSize);
  final loupeCenter = loupeRect.center;

 final sourceWidth = (loupeSize / zoom) * (image.width / imageRect.width);
final sourceHeight = (loupeSize / zoom) * (image.height / imageRect.height);

// Canvas point ni original image pixel source rect ki convert chestham.
final sourceCenterX =
    ((point.dx - imageRect.left) / imageRect.width) * image.width;
final sourceCenterY =
    ((point.dy - imageRect.top) / imageRect.height) * image.height;

final sourceRect = Rect.fromCenter(
  center: Offset(sourceCenterX, sourceCenterY),
  width: sourceWidth,
  height: sourceHeight,
).intersect(
  Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
);

canvas.save();

final clipPath = Path()..addOval(loupeRect);
canvas.clipPath(clipPath);

canvas.drawImageRect(
  image,
  sourceRect,
  loupeRect,
  Paint()
    ..filterQuality = FilterQuality.high
    ..isAntiAlias = true,
);

  canvas.restore();

  final borderPaint = Paint()
    ..color = AppColors.primary
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3;

  canvas.drawOval(loupeRect, borderPaint);

  final crossPaint = Paint()
    ..color = Colors.white
    ..strokeWidth = 1.4;

  canvas.drawLine(
    Offset(loupeCenter.dx - 10, loupeCenter.dy),
    Offset(loupeCenter.dx + 10, loupeCenter.dy),
    crossPaint,
  );
  canvas.drawLine(
    Offset(loupeCenter.dx, loupeCenter.dy - 10),
    Offset(loupeCenter.dx, loupeCenter.dy + 10),
    crossPaint,
  );
}

  @override
  bool shouldRepaint(covariant _CropOverlayPainter oldDelegate) {
    return oldDelegate.image != image ||
    oldDelegate.imageRect != imageRect ||
    oldDelegate.cropPoints != cropPoints ||
    oldDelegate.isInvalid != isInvalid ||
    oldDelegate.magnifierPoint != magnifierPoint;
  }
}
