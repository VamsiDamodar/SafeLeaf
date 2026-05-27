import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeleaf/modules/enhance_document_images/enhance_document_image_viewmodel.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/widgets/common/safeleaf_page_app_bar.dart';
import 'package:safeleaf/widgets/enhance_image_documets/enhance_document_image_content.dart';

class EnhanceDocumentView extends GetView<EnhanceDocumentViewModel> {
  const EnhanceDocumentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: SafeLeafPageAppBar(
        title: 'Edit & Enhance',
        onBackTap: controller.onBackTap,
      ),
      body: SafeArea(
        child: Obx(
          () => EnhanceDocumentContent(
            files: controller.files,
            currentIndex: controller.currentIndex.value,
            totalCount: controller.imageCount,
            extension: controller.currentExtension,
            pdfPageCount: controller.pdfPageCount.value,
            rotationTurns: controller.currentRotationTurns,
            selectedFilterIndex: controller.selectedFilterIndex.value,
            applyFilterToAllPages: controller.applyFilterToAllPages.value,
            onPreviousTap: controller.onPreviousTap,
            onNextImageTap: controller.onNextImageTap,
            onRotateTap: controller.onRotateTap,
            onCropTap: controller.onCropTap,
            onDeleteTap: controller.onDeleteTap,
            onFilterTap: controller.onFilterTap,
            onApplyToAllPagesChanged: controller.onApplyToAllPagesChanged,
            onBackTap: controller.onBackTap,
            onNextTap: controller.onContinueTap,
          ),
        ),
      ),
    );
  }
}
