import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeleaf/modules/upload_document/upload_document_viewmodel.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/utils/app_textstyles.dart';

class UploadDocumentView extends GetView<UploadDocumentViewModel> {
  const UploadDocumentView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        // final screenWidth * 0.06 = screenWidth * 0.06;
       
        final headingFontSize = screenWidth * 0.05;
        final subTextFontSize = screenWidth * 0.034;
        final smallTextFontSize = screenWidth * 0.031;
        final buttonHeight = screenHeight * 0.068;
        final buttonFontSize = screenWidth * 0.039;
        final iconSize = screenWidth * 0.052;
        final appBarTitleSize = screenWidth * 0.043;
        return Scaffold(
          backgroundColor: AppColors.surface,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              onPressed: controller.onBackTap,
              icon: Icon(
                Icons.arrow_back_rounded,
                color: AppColors.primaryDark,
                size: screenWidth * 0.075,
              ),
            ),
            title: Text(
              'Upload Document',
              style: AppTextStyles.drawerItem.copyWith(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w600,
                fontSize: appBarTitleSize,
              ),
            ),
            actions: [
              SizedBox(width: screenWidth * 0.12),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child: Column(
                children: [
                  Center(
                    child: Image.asset(
                      'assets/upload_doc_image.png',
                      height: 400,
                      width: 400,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Text(
                    'Upload your document',
                    style: AppTextStyles.drawerHeaderTitle.copyWith(
                      color: AppColors.primary,
                      fontSize: headingFontSize,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: screenHeight * 0.012),

                  Text(
                    'Supported formats: PDF, JPG, PNG',
                    style: AppTextStyles.drawerItem.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: subTextFontSize,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: screenHeight * 0.005),

                  Text(
                    'Max size: 10MB',
                    style: AppTextStyles.drawerFooter.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: smallTextFontSize,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    height: buttonHeight.clamp(48, 58),
                    child: ElevatedButton.icon(
                      onPressed: controller.onChooseFileTap,
                      icon: Icon(
                        Icons.description_outlined,
                        color: Colors.white,
                        size: iconSize,
                      ),
                      label: Text(
                        'Choose File',
                        style: AppTextStyles.drawerItem.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: buttonFontSize,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.04),
                        ),
                      ),
                    ),
                  ),

                 SizedBox(height: screenHeight * 0.02),

                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: AppColors.textSecondary.withOpacity(0.4),
                          thickness: 1,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'or',
                          style: AppTextStyles.drawerFooter.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: smallTextFontSize,
                          ),
                        ),
                      ),

                      Expanded(
                        child: Divider(
                          color: AppColors.textSecondary.withOpacity(0.4),
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.02),
                  SizedBox(
                    width: double.infinity,
                    height: buttonHeight.clamp(48, 58),
                    child: OutlinedButton.icon(
                      onPressed: controller.onScanDocumentTap,
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        color: AppColors.primary,
                        size: iconSize,
                      ),
                      label: Text(
                        'Scan Document',
                        style: AppTextStyles.drawerItem.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: buttonFontSize,
                        ),
                      ),
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
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.09),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}