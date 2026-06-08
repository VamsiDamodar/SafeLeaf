import 'dart:io';

import 'package:flutter/material.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/utils/app_textstyles.dart';
import 'package:safeleaf/widgets/enhance_image_documets/document_flow_action_buttons.dart';
import 'package:safeleaf/widgets/enhance_image_documets/enhance_edit_tools.dart';
import 'package:safeleaf/widgets/enhance_image_documets/enhance_filter_strip.dart';
import 'package:safeleaf/widgets/enhance_image_documets/enhance_image_preview.dart';
import 'package:safeleaf/widgets/enhance_image_documets/enhance_page_controls.dart';

class EnhanceDocumentContent extends StatelessWidget {
  final List<File> files;
  final int currentIndex;
  final int totalCount;
  final int rotationTurns;
  final int selectedFilterIndex;
  final VoidCallback onPreviousTap;
  final VoidCallback onNextImageTap;
  final VoidCallback onRotateTap;
  final VoidCallback onCropTap;
  final VoidCallback onDeleteTap;
  final void Function(int index) onFilterTap;
  final VoidCallback onBackTap;
  final VoidCallback onNextTap;
  final String extension;
  final int? pdfPageCount;
  final bool applyFilterToAllPages;
  final void Function(bool value) onApplyToAllPagesChanged;

  const EnhanceDocumentContent({
    super.key,
    required this.files,
    required this.currentIndex,
    required this.totalCount,
    required this.rotationTurns,
    required this.selectedFilterIndex,
    required this.onPreviousTap,
    required this.onNextImageTap,
    required this.onRotateTap,
    required this.onCropTap,
    required this.onDeleteTap,
    required this.onFilterTap,
    required this.onBackTap,
    required this.onNextTap,
    required this.extension,
    required this.pdfPageCount,
    required this.applyFilterToAllPages,
    required this.onApplyToAllPagesChanged,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final horizontalPadding = (size.width * 0.05).clamp(16.0, 24.0).toDouble();
    final gap = (size.width * 0.035).clamp(12.0, 18.0).toDouble();
    final buttonHeight = (size.height * 0.065).clamp(50.0, 60.0).toDouble();
    final isPdf = extension == 'pdf';

    if (files.isEmpty) {
      return const Center(child: Text('No images selected'));
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              18,
              horizontalPadding,
              16,
            ),
            child: Column(
              children: [
                if (isPdf) ...[
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(.10),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(.18),
                        ),
                      ),
                      child: Text(
                        _pdfPageCountText(),
                        style: AppTextStyles.drawerItem.copyWith(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: gap * .6),
                ],
                EnhanceImagePreview(
                  file: files[currentIndex],
                  extension: extension,
                  rotationTurns: rotationTurns,
                  selectedFilterIndex: selectedFilterIndex,
                  showAllPdfPages: isPdf,
                  pdfPageCount: pdfPageCount,
                ),
                if (totalCount > 1) ...[
                  SizedBox(height: gap),
                  EnhancePageControls(
                    currentIndex: currentIndex,
                    totalCount: totalCount,
                    onPreviousTap: onPreviousTap,
                    onNextTap: onNextImageTap,
                  ),
                ],
                SizedBox(height: isPdf ? gap * 5 : gap * 1.3),
                if (!isPdf) ...[
                  EnhanceEditTools(
                    onRotateTap: onRotateTap,
                    onCropTap: onCropTap,
                    onDeleteTap: onDeleteTap,
                  ),
                  SizedBox(height: gap * 1.4),
                ] else
                  SizedBox(height: gap * .4),
                EnhanceFilterStrip(
                  file: files[currentIndex],
                  extension: extension,
                  selectedIndex: selectedFilterIndex,
                  applyToAllPages: applyFilterToAllPages,
                  onApplyToAllPagesChanged: onApplyToAllPagesChanged,
                  onFilterTap: onFilterTap,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(horizontalPadding, 10, horizontalPadding, 18),
          child: DocumentFlowActionButtons(
            gap: gap,
            buttonHeight: buttonHeight,
            leftLabel: 'Back',
            rightLabel: 'Next',
            leftIcon: Icons.arrow_back_rounded,
            rightIcon: Icons.arrow_forward_rounded,
            onLeftTap: onBackTap,
            onRightTap: onNextTap,
          ),
        ),
      ],
    );
  }

  String _pdfPageCountText() {
    final count = pdfPageCount;
    if (count == null || count <= 0) return 'PDF pages';
    return count == 1 ? 'PDF - 1 page' : 'PDF - $count pages';
  }
}
