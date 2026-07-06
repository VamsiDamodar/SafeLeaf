import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeleaf/modules/saved_document/saved_document_viewmodel.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/utils/app_textstyles.dart';
import 'package:safeleaf/widgets/common/safeleaf_page_app_bar.dart';
import 'package:safeleaf/widgets/preview/document_preview_card.dart';

class SavedDocumentView extends GetView<SavedDocumentViewModel> {
  const SavedDocumentView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        final previewHeight = (screenHeight * 0.42).clamp(230.0, 380.0).toDouble();
        final titleFontSize = (screenWidth * 0.046).clamp(16.0, 22.0).toDouble();
        final metaFontSize = (screenWidth * 0.032).clamp(12.0, 15.0).toDouble();
        final buttonHeight = (screenHeight * 0.064).clamp(48.0, 58.0).toDouble();
        final buttonFontSize = (screenWidth * 0.038).clamp(13.0, 16.0).toDouble();

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: SafeLeafPageAppBar(
            title: 'Saved Document',
            onBackTap: controller.onBackTap,
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child: Obx(() {
                final file = controller.file;
                if (file == null || !controller.hasFile) {
                  return Center(
                    child: Text(
                      'Saved file not found.',
                      style: AppTextStyles.drawerItem.copyWith(
                        color: AppColors.primaryDark,
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: AppColors.surfaceBorder),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryDark.withOpacity(0.06),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 54,
                            height: 54,
                            decoration: const BoxDecoration(
                              color: AppColors.iconBackground,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: AppColors.safe,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Document saved',
                                  style: AppTextStyles.drawerHeaderTitle.copyWith(
                                    color: AppColors.primaryDark,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  controller.categoryName.value.isEmpty
                                      ? controller.fileName.value
                                      : controller.categoryName.value,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.drawerItem.copyWith(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Expanded(
                      child: Center(
                        child: DocumentPreviewCard(
                          height: previewHeight,
                          screenWidth: screenWidth,
                          file: file,
                          extension: controller.extension.value.isEmpty
                              ? _guessExtension(file.path)
                              : controller.extension.value,
                          pageCount: null,
                          isMultipleImages: false,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      controller.fileName.value.isEmpty
                          ? file.path.split(Platform.pathSeparator).last
                          : controller.fileName.value,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.drawerHeaderTitle.copyWith(
                        color: AppColors.primaryDark,
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.008),
                    Text(
                      '${controller.extension.value.toUpperCase()} . ${controller.getReadableSize()}',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.drawerItem.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: metaFontSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: buttonHeight,
                            child: OutlinedButton(
                              onPressed: controller.onBackTap,
                              style: OutlinedButton.styleFrom(
                                backgroundColor: AppColors.surface,
                                side: const BorderSide(
                                  color: AppColors.surfaceBorder,
                                  width: 1.2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.04),
                                ),
                              ),
                              child: Text(
                                'Back',
                                style: AppTextStyles.drawerItem.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: buttonFontSize,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.035),
                        Expanded(
                          child: SizedBox(
                            height: buttonHeight,
                            child: ElevatedButton(
                              onPressed: controller.onGoHomeTap,
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.04),
                                ),
                              ),
                              child: Text(
                                'Go Home',
                                style: AppTextStyles.drawerItem.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: buttonFontSize,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.03),
                  ],
                );
              }),
            ),
          ),
        );
      },
    );
  }

  String _guessExtension(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.jpeg')) return 'jpeg';
    if (lower.endsWith('.png')) return 'png';
    if (lower.endsWith('.pdf')) return 'pdf';
    if (lower.endsWith('.docx')) return 'docx';
    if (lower.endsWith('.doc')) return 'doc';
    return 'jpg';
  }
}
