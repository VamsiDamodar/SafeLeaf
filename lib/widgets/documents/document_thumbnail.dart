import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class DocumentThumbnail extends StatelessWidget {
  final String? path;

  const DocumentThumbnail({
    super.key,
    this.path,
  });

  @override
  Widget build(BuildContext context) {
    if (path == null || path!.trim().isEmpty) {
      return Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.picture_as_pdf),
      );
    }

    final file = File(path!);
    final lower = path!.toLowerCase();
    final isPdf = lower.endsWith('.pdf');

    if (isPdf && file.existsSync()) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FutureBuilder<Uint8List?>(
          future: _renderPdfFirstPage(file),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return Image.memory(
                snapshot.data!,
                width: 65,
                height: 65,
                fit: BoxFit.cover,
                gaplessPlayback: true,
              );
            }

            return Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.picture_as_pdf),
            );
          },
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.file(
        file,
        width: 65,
        height: 65,
        fit: BoxFit.cover,
      ),
    );
  }

  Future<Uint8List?> _renderPdfFirstPage(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final pages = await Printing.raster(bytes, pages: const [0], dpi: 120).toList();
      if (pages.isEmpty) return null;
      return pages.first.toPng();
    } catch (_) {
      return null;
    }
  }
}
