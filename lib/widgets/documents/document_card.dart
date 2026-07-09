import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:safeleaf/data/models/document_model.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/utils/app_textstyles.dart';

class DocumentCard extends StatelessWidget {
  final DocumentModel document;
  final VoidCallback? onTap;
  final VoidCallback? onMoreTap;

  const DocumentCard({
    super.key,
    required this.document,
    this.onTap,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    final fileType = _fileType(document.filePath);
    final fileSize = _fileSize(document.filePath);
    final date = _formatDate(document.issueDate ?? document.createdAt);

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.cardBorder,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryDark.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Row(
                children: [
                  _DocumentPreview(path: document.filePath),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            document.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.drawerItem.copyWith(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Poppins',
                              height: 1.15,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _MetaRow(
                            icon: Icons.calendar_today_outlined,
                            text: date,
                          ),
                          const SizedBox(height: 6),
                          _MetaRow(
                            icon: Icons.insert_drive_file_outlined,
                            text: '$fileType - $fileSize',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: -8,
                right: -8,
                child: IconButton(
                  onPressed: onMoreTap,
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: AppColors.primaryDark,
                  ),
                  iconSize: 24,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String value) {
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return value;
    return DateFormat('dd MMM yyyy').format(parsed);
  }

  String _fileType(String? path) {
    if (path == null || path.trim().isEmpty) return 'PDF';

    final extension = path.split('.').last.toUpperCase();
    if (extension.length > 5 || extension == path.toUpperCase()) return 'PDF';

    return extension;
  }

  String _fileSize(String? path) {
    if (path == null || path.trim().isEmpty) return '1.08 MB';

    final file = File(path);
    if (!file.existsSync()) return '1.08 MB';

    final bytes = file.lengthSync();
    if (bytes < 1024) return '$bytes B';

    final kb = bytes / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(0)} KB';

    final mb = kb / 1024;
    return '${mb.toStringAsFixed(2)} MB';
  }
}

class _DocumentPreview extends StatelessWidget {
  final String? path;

  const _DocumentPreview({
    this.path,
  });

  @override
  Widget build(BuildContext context) {
    final hasFile = path != null && path!.trim().isNotEmpty;
    final file = hasFile ? File(path!) : null;
    final isImage = hasFile && _isImage(path!);
    final isPdf = hasFile && _isPdf(path!);

    return Container(
      width: 92,
      height: 72,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: _buildPreview(file, isImage, isPdf),
      ),
    );
  }

  Widget _buildPreview(File? file, bool isImage, bool isPdf) {
    if (isImage && file != null && file.existsSync()) {
      return Image.file(
        file,
        fit: BoxFit.cover,
      );
    }

    if (isPdf && file != null && file.existsSync()) {
      return FutureBuilder<Uint8List?>(
        future: _renderPdfFirstPage(file),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Image.memory(
              snapshot.data!,
              fit: BoxFit.cover,
              gaplessPlayback: true,
            );
          }

          return _buildPdfFallback();
        },
      );
    }

    return _buildPdfFallback();
  }

  Widget _buildPdfFallback() {
    return Container(
      color: Colors.white,
      child: const Icon(
        Icons.picture_as_pdf_rounded,
        color: AppColors.primary,
        size: 34,
      ),
    );
  }

  bool _isImage(String path) {
    final lower = path.toLowerCase();
    return lower.endsWith('.png') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.webp');
  }

  bool _isPdf(String path) {
    return path.toLowerCase().endsWith('.pdf');
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

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 15,
          color: const Color(0xFF69717F),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.drawerFooter.copyWith(
              color: const Color(0xFF4F5665),
              fontSize: 10,
              fontWeight: FontWeight.w500,
              height: 1.1,
            ),
          ),
        ),
      ],
    );
  }
}
