import 'package:flutter/material.dart';
import 'package:safeleaf/utils/app_colors.dart';

/// The SafeLeaf app icon — Document + Lock.
/// Drawn with CustomPainter so it scales perfectly at any size.
class SafeLeafIcon extends StatelessWidget {
  final double size;
  const SafeLeafIcon({super.key, this.size = 88});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.11),
        borderRadius: BorderRadius.circular(size * 0.27),
        border: Border.all(
          color: AppColors.primaryLight.withOpacity(0.4),
          width: 1.5,
        ),
      ),
      child: Center(
        child: CustomPaint(
          size: Size(size * 0.68, size * 0.68),
          painter: _DocLockPainter(),
        ),
      ),
    );
  }
}

class _DocLockPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ══════════════════════════════════════════════════════════════
    // ── LAYER 1: DOCUMENT (Back layer) ────────────────────────────
    // ══════════════════════════════════════════════════════════════
    
    // Document body - medium green
    final docPaint = Paint()
      ..color = const Color(0xFF52B788) // Exact from image
      ..style = PaintingStyle.fill;

    final docRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, w * 0.60, h * 0.75),
      Radius.circular(w * 0.10),
    );
    canvas.drawRRect(docRect, docPaint);

    // Folded corner - light mint green
    final cornerPath = Path()
      ..moveTo(w * 0.38, 0)
      ..lineTo(w * 0.60, h * 0.22)
      ..lineTo(w * 0.38, h * 0.22)
      ..close();
    canvas.drawPath(
      cornerPath,
      Paint()..color = const Color(0xFFA8DABC), // Exact from image
    );

    // Doc lines - dark forest green
    final linePaint = Paint()
      ..color = const Color(0xFF1B4332) // Exact from image
      ..strokeWidth = h * 0.040
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(w * 0.12, h * 0.38),
      Offset(w * 0.50, h * 0.38),
      linePaint,
    );
    canvas.drawLine(
      Offset(w * 0.12, h * 0.48),
      Offset(w * 0.38, h * 0.48),
      linePaint,
    );

    // ══════════════════════════════════════════════════════════════
    // ── LAYER 2: LOCK BODY (Middle layer) ─────────────────────────
    // ══════════════════════════════════════════════════════════════
    
    // Lock body - off-white
    final lockBodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.38, h * 0.52, w * 0.58, h * 0.44),
      Radius.circular(w * 0.10),
    );
    canvas.drawRRect(
      lockBodyRect,
      Paint()..color = const Color(0xFFF0F4F1), // Exact from image
    );

    // Keyhole circle - dark forest green
    canvas.drawCircle(
      Offset(w * 0.67, h * 0.715),
      w * 0.075,
      Paint()..color = const Color(0xFF1B4332),
    );

    // Keyhole stem - dark forest green
    final stemRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.635, h * 0.715, w * 0.07, h * 0.12),
      const Radius.circular(4),
    );
    canvas.drawRRect(stemRect, Paint()..color = const Color(0xFF1B4332));

    // ══════════════════════════════════════════════════════════════
    // ── LAYER 3: LOCK SHACKLE (Top layer - most visible!) ─────────
    // ══════════════════════════════════════════════════════════════
    
    // Shackle - dark forest green, thicker stroke
    final shacklePaint = Paint()
      ..color = const Color(0xFF1B4332) // Exact from image
      ..strokeWidth = h * 0.060 // Slightly thicker to match image
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final shacklePath = Path()
      ..moveTo(w * 0.49, h * 0.52)
      ..lineTo(w * 0.49, h * 0.40)
      ..arcToPoint(
        Offset(w * 0.83, h * 0.40),
        radius: Radius.circular(w * 0.17),
        clockwise: false,
      )
      ..lineTo(w * 0.83, h * 0.52);
    canvas.drawPath(shacklePath, shacklePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}