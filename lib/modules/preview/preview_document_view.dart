import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeleaf/modules/preview/preview_document_viewmodel.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/utils/app_textstyles.dart';
import 'package:safeleaf/widgets/common/safeleaf_page_app_bar.dart';
import 'package:safeleaf/widgets/preview/document_preview_card.dart';
import 'package:safeleaf/widgets/preview/empty_preview.dart';


class PreviewDocumentView extends GetView<PreviewDocumentViewModel> {
  const PreviewDocumentView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        final horizontalPadding = screenWidth * 0.06;
        final previewHeight = (screenHeight * 0.40).clamp(210.0, 350.0).toDouble();
        final titleFontSize = (screenWidth * 0.046).clamp(16.0, 21.0).toDouble();
        final metaFontSize = (screenWidth * 0.033).clamp(12.0, 15.0).toDouble();
        final buttonHeight = (screenHeight * 0.064).clamp(48.0, 58.0).toDouble();
        final buttonFontSize = (screenWidth * 0.038).clamp(13.0, 16.0).toDouble();

        return Scaffold(
          backgroundColor: AppColors.surface,
          appBar: SafeLeafPageAppBar(
            title: 'Document Preview',
            onBackTap: controller.onBackTap,
          ),
          body: SafeArea(
            child: Obx(() {
              if (!controller.hasFiles) {
                return EmptyPreview(onChangeFileTap: controller.onChangeFileTap);
              }
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  children: [
                    const Spacer(),
                    Center(
                      child: DocumentPreviewCard(
                        height: previewHeight,
                        screenWidth: screenWidth,
                        file: controller.files.first,
                        extension: controller.extension,
                        pageCount: controller.pageCount,
                        isMultipleImages: controller.isMultipleImages,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      controller.fileName,
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
                      '${controller.extension.toUpperCase()} . ${controller.getReadableSize()} . ${controller.getPageCountText()}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.drawerItem.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: metaFontSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: buttonHeight,
                            child: OutlinedButton(
                              onPressed: controller.onChangeFileTap,
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
                                'Change File',
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
                              onPressed: controller.onNextTap,
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.04),
                                ),
                              ),
                              child: Text(
                                'Next',
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
                    SizedBox(height: screenHeight * 0.035),
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
