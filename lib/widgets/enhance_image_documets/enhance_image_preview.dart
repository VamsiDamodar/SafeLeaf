import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:safeleaf/utils/app_colors.dart';

class EnhanceImagePreview extends StatefulWidget {
  final File file;
  final int rotationTurns;
  final int selectedFilterIndex;
  final String extension;
  final double? height;
  final bool showAllPdfPages;
  final int? pdfPageCount;

  const EnhanceImagePreview({
    super.key,
    required this.file,
    required this.rotationTurns,
    required this.selectedFilterIndex,
    required this.extension,
    this.height,
    this.showAllPdfPages = false,
    this.pdfPageCount,
  });

  @override
  State<EnhanceImagePreview> createState() => _EnhanceImagePreviewState();
}

class _EnhanceImagePreviewState extends State<EnhanceImagePreview> {
  final _pdfPageFutures = <int, Future<Uint8List>>{};
  String? _cachedFilePath;

  @override
  void initState() {
    super.initState();
    _cachePdfFutureIfNeeded();
  }

  @override
  void didUpdateWidget(covariant EnhanceImagePreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    _cachePdfFutureIfNeeded();
  }

  void _cachePdfFutureIfNeeded() {
    if (widget.extension != 'pdf') {
      _pdfPageFutures.clear();
      _cachedFilePath = null;
      return;
    }

    if (_cachedFilePath == widget.file.path) {
      return;
    }

    _cachedFilePath = widget.file.path;
    _pdfPageFutures.clear();
  }

  @override
  Widget build(BuildContext context) {
    final previewHeight =
        widget.height ??
        (MediaQuery.sizeOf(context).width * 0.90).clamp(280.0, 520.0).toDouble();

    return Container(
      width: double.infinity,
      height: previewHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.cardBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: RotatedBox(
        quarterTurns: widget.rotationTurns,
        child: ColorFiltered(
          colorFilter: _filterForIndex(widget.selectedFilterIndex),
          child: widget.extension == 'pdf'
              ? _buildPdfPreview()
              : Padding(
                padding: const EdgeInsets.all(10),
                child: Image.file(
                  widget.file,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
        ),
      ),
    );
  }

  Widget _buildPdfPreview() {
    final pageCount = widget.showAllPdfPages ? widget.pdfPageCount : 1;

    if (!widget.showAllPdfPages || pageCount == null || pageCount <= 1) {
      return _PdfPagePreview(
        pageNumber: 1,
        future: _pdfPageFuture(0),
        showPageLabel: widget.showAllPdfPages,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(10),
      itemCount: pageCount,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return _PdfPagePreview(
          pageNumber: index + 1,
          future: _pdfPageFuture(index),
          showPageLabel: true,
        );
      },
    );
  }

  Future<Uint8List> _pdfPageFuture(int pageIndex) {
    return _pdfPageFutures.putIfAbsent(
      pageIndex,
      () => _renderPdfPage(widget.file, pageIndex),
    );
  }

  Future<Uint8List> _renderPdfPage(File file, int pageIndex) async {
    final bytes = await file.readAsBytes();
    final rasterPages = await Printing.raster(
      bytes,
      pages: [pageIndex],
      dpi: 120,
    ).toList();

    if (rasterPages.isEmpty) {
      throw StateError('Unable to render PDF preview');
    }

    return rasterPages.first.toPng();
  }

  ColorFilter _filterForIndex(int index) {
    switch (index) {
      case 1:
        return const ColorFilter.mode(Colors.white24, BlendMode.lighten);
      case 2:
        return const ColorFilter.mode(Color(0x22FFC107), BlendMode.overlay);
      case 3:
        return const ColorFilter.matrix(<double>[
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0, 0, 0, 1, 0,
        ]);
      case 4:
        return const ColorFilter.matrix(<double>[
          1.5, 1.5, 1.5, 0, -180,
          1.5, 1.5, 1.5, 0, -180,
          1.5, 1.5, 1.5, 0, -180,
          0, 0, 0, 1, 0,
        ]);
      case 5:
        return const ColorFilter.mode(Color(0x22FF9800), BlendMode.overlay);
      default:
        return const ColorFilter.mode(Colors.transparent, BlendMode.dst);
    }
  }
}

class _PdfPagePreview extends StatelessWidget {
  final int pageNumber;
  final Future<Uint8List> future;
  final bool showPageLabel;

  const _PdfPagePreview({
    required this.pageNumber,
    required this.future,
    required this.showPageLabel,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox(
            height: 180,
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const SizedBox(
            height: 180,
            child: Center(child: Icon(Icons.picture_as_pdf_rounded)),
          );
        }

        return DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Stack(
              children: [
                Image.memory(
                  snapshot.data!,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
                if (showPageLabel)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.62),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Page $pageNumber',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
