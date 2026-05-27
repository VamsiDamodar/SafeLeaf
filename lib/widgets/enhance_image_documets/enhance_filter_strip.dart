import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/utils/app_textstyles.dart';
import 'package:safeleaf/widgets/enhance_image_documets/enhance_image_preview.dart';

class EnhanceFilterStrip extends StatefulWidget {
  final File file;
  final int selectedIndex;
  final void Function(int index) onFilterTap;
  final String extension;
  final bool applyToAllPages;
  final void Function(bool value) onApplyToAllPagesChanged;

  const EnhanceFilterStrip({
    super.key,
    required this.file,
    required this.selectedIndex,
    required this.onFilterTap,
    required this.extension,
    required this.applyToAllPages,
    required this.onApplyToAllPagesChanged,
  });

  @override
  State<EnhanceFilterStrip> createState() => _EnhanceFilterStripState();
}

class _EnhanceFilterStripState extends State<EnhanceFilterStrip> {
  Future<Uint8List>? _pdfFirstPageFuture;
  String? _cachedFilePath;

  static const filters = [
    'Original',
    'Brighten',
    'Magic Color',
    'Grayscale',
    'B&W',
    'Warm',
  ];

  @override
  void initState() {
    super.initState();
    _cachePdfFirstPageIfNeeded();
  }

  @override
  void didUpdateWidget(covariant EnhanceFilterStrip oldWidget) {
    super.didUpdateWidget(oldWidget);
    _cachePdfFirstPageIfNeeded();
  }

  void _cachePdfFirstPageIfNeeded() {
    if (widget.extension != 'pdf') {
      _pdfFirstPageFuture = null;
      _cachedFilePath = null;
      return;
    }

    if (_cachedFilePath == widget.file.path && _pdfFirstPageFuture != null) {
      return;
    }

    _cachedFilePath = widget.file.path;
    _pdfFirstPageFuture = _renderPdfFirstPage(widget.file);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Apply to all pages',
                style: AppTextStyles.drawerItem.copyWith(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Switch(
              value: widget.applyToAllPages,
              activeColor: AppColors.primary,
              onChanged: widget.onApplyToAllPagesChanged,
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 118,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final isSelected = widget.selectedIndex == index;

              return GestureDetector(
                onTap: () => widget.onFilterTap(index),
                child: SizedBox(
                  width: 82,
                  child: Column(
                    children: [
                      Container(
                        height: 72,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.cardBorder,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: widget.extension == 'pdf'
                            ? _PdfFilterTilePreview(
                                filterIndex: index,
                                firstPageFuture: _pdfFirstPageFuture,
                              )
                            : EnhanceImagePreview(
                                file: widget.file,
                                extension: widget.extension,
                                rotationTurns: 0,
                                selectedFilterIndex: index,
                                height: 72,
                              ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        filters[index],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.drawerItem.copyWith(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<Uint8List> _renderPdfFirstPage(File file) async {
    final bytes = await file.readAsBytes();
    final pages = await Printing.raster(bytes, pages: const [0], dpi: 80).toList();

    if (pages.isEmpty) {
      throw StateError('Unable to render PDF filter preview');
    }

    return pages.first.toPng();
  }
}

class _PdfFilterTilePreview extends StatelessWidget {
  final int filterIndex;
  final Future<Uint8List>? firstPageFuture;

  const _PdfFilterTilePreview({
    required this.filterIndex,
    required this.firstPageFuture,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: firstPageFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2,
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: Icon(
              Icons.picture_as_pdf_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          );
        }

        return ColorFiltered(
          colorFilter: _filterForIndex(filterIndex),
          child: Image.memory(
            snapshot.data!,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        );
      },
    );
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
