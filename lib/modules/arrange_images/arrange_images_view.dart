import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeleaf/modules/arrange_images/arrange_images_viewmodel.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/widgets/arrange_images/rearrange_documents_content.dart';
import 'package:safeleaf/widgets/common/safeleaf_page_app_bar.dart';

class ArrangeImagesView extends GetView<ArrangeImagesViewModel> {
  const ArrangeImagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: SafeLeafPageAppBar(
        title: 'Re-arrange Images',
        onBackTap: controller.onBackTap,
      ),
      body: SafeArea(
        child: Obx(
          () => RearrangeDocumentsContent(
            files: controller.files,
            imageCount: controller.imageCount,
            getFileName: controller.getFileName,
            getReadableSize: controller.getReadableSize,
            onMoveImage: controller.moveImage,
            onAddMoreTap: controller.onAddMoreTap,
            onNextTap: controller.onNextTap,
          ),
        ),
      ),
    );
  }
}