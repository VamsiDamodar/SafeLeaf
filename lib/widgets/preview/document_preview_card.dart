import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'file_icon_preview.dart';
import 'page_badge.dart';

class DocumentPreviewCard extends StatelessWidget {
  final double height;
  final double screenWidth;
  final File file;
  final String extension;
  final int? pageCount;
  final bool isMultipleImages;

  const DocumentPreviewCard({
    super.key,
    required this.height,
    required this.screenWidth,
    required this.file,
    required this.extension,
    required this.pageCount,
    required this.isMultipleImages,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Center(
        child: Container(
          width: screenWidth * 0.7,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 3),
                color: Colors.black.withOpacity(.08),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: _buildPreviewContent(),
        ),
      ),
    );
  }

  Widget _buildPreviewContent() {
    if (['jpg', 'jpeg', 'png'].contains(extension)) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.file(file, fit: BoxFit.contain),
          if (isMultipleImages)
            Positioned(
              right: 12,
              top: 12,
              child: PageBadge(text: '$pageCount pages'),
            ),
        ],
      );
    }

    if (extension == 'pdf') {
      return FutureBuilder<Uint8List>(
        future: _renderPdfFirstPage(file),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          if (!snapshot.hasData) {
            return FileIconPreview(extension: extension, screenWidth: screenWidth);
          }
          return Image.memory(snapshot.data!, fit: BoxFit.contain);
        },
      );
    }

    return FileIconPreview(extension: extension, screenWidth: screenWidth);
  }

  Future<Uint8List> _renderPdfFirstPage(File file) async {
    final bytes = await file.readAsBytes();
    final pages = await Printing.raster(bytes, pages: const [0], dpi: 120).toList();
    if (pages.isEmpty) throw StateError('Unable to render PDF preview');
    return pages.first.toPng();
  }
}
