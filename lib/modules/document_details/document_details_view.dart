import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeleaf/modules/document_details/document_details_viewmodel.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/utils/app_textstyles.dart';
import 'package:safeleaf/widgets/common/safeleaf_page_app_bar.dart';

class DocumentDetailsView extends GetView<DocumentDetailsViewModel> {
  const DocumentDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: SafeLeafPageAppBar(
        title: 'Document Details',
        onBackTap: controller.onBackTap,
      ),
      body: SafeArea(
        child: Obx(
          () => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Document details placeholder\n\n${controller.fileName}',
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