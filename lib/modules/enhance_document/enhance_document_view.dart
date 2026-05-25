import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeleaf/modules/enhance_document/enhance_document_viewmodel.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/utils/app_textstyles.dart';
import 'package:safeleaf/widgets/common/safeleaf_page_app_bar.dart';

class EnhanceDocumentView extends GetView<EnhanceDocumentViewModel> {
  const EnhanceDocumentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: SafeLeafPageAppBar(
        title: 'Enhance Document',
        onBackTap: controller.onBackTap,
      ),
      body: SafeArea(
        child: Obx(
          () => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Enhance options placeholder\n\n${controller.fileName}\n${controller.extension}',
                textAlign: TextAlign.center,
                style: AppTextStyles.drawerItem.copyWith(
                  color: AppColors.primaryDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}