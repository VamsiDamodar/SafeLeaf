import 'dart:io';
import 'package:flutter/material.dart';

class DocumentThumbnail extends StatelessWidget {
  final String? path;

  const DocumentThumbnail({
    super.key,
    this.path,
  });

  @override
  Widget build(BuildContext context) {
    if (path == null) {
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

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.file(
        File(path!),
        width: 65,
        height: 65,
        fit: BoxFit.cover,
      ),
    );
  }
}
