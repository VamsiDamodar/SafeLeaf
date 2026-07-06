import 'dart:io';
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        final previewHeight = (screenHeight * 0.46).clamp(250.0, 430.0).toDouble();
        final titleFontSize = (screenWidth * 0.046).clamp(16.0, 22.0).toDouble();
        final metaFontSize = (screenWidth * 0.032).clamp(12.0, 15.0).toDouble();
        final actionFontSize = (screenWidth * 0.034).clamp(12.0, 14.0).toDouble();

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: SafeLeafPageAppBar(
            title: 'Document Viewer',
            onBackTap: controller.onBackTap,
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.surfaceBorder.withOpacity(0.8))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: controller.onShareTap,
                      icon: const Icon(Icons.share_outlined, size: 18),
                      label: Text(
                        'Share',
                        style: AppTextStyles.drawerItem.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: actionFontSize,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.surface,
                        side: const BorderSide(color: AppColors.surfaceBorder, width: 1.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: controller.onEditTap,
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: Text(
                        'Edit',
                        style: AppTextStyles.drawerItem.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: actionFontSize,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.surface,
                        side: const BorderSide(color: AppColors.surfaceBorder, width: 1.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: controller.onRenameTap,
                      icon: const Icon(Icons.drive_file_rename_outline_rounded, size: 18),
                      label: Text(
                        'Rename',
                        style: AppTextStyles.drawerItem.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: actionFontSize,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child: Obx(() {
                final file = controller.file;
                if (file == null || !controller.hasFile) {
                  return Center(
                    child: Text(
                      'Document not found.',
                      style: AppTextStyles.drawerItem.copyWith(
                        color: AppColors.primaryDark,
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    Expanded(
                      child: controller.isPdf
                          ? _PdfViewer(
                              controller: controller,
                              screenWidth: screenWidth,
                            )
                          : _ImageViewer(
                              filePath: file.path,
                              height: previewHeight,
                              screenWidth: screenWidth,
                            ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      controller.fileName.value,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.drawerHeaderTitle.copyWith(
                        color: AppColors.primaryDark,
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      controller.isPdf
                          ? 'Swipe pages or use arrows to navigate'
                          : 'Saved in SafeLeaf secure storage',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.drawerItem.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: metaFontSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                  ],
                );
              }),
            ),
          ),
        );
      },
    );
  }
}



class _ImageViewer extends StatelessWidget {
  final String filePath;
  final double height;
  final double screenWidth;

  const _ImageViewer({
    required this.filePath,
    required this.height,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: height,
        width: screenWidth * 0.92,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.file(
          File(filePath),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _PdfViewer extends StatelessWidget {
  final DocumentDetailsViewModel controller;
  final double screenWidth;

  const _PdfViewer({
    required this.controller,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.isPdfLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (controller.pdfPages.isEmpty) {
          return const Center(
            child: Icon(Icons.picture_as_pdf_rounded, color: AppColors.primary),
          );
        }

        final total = controller.pdfPages.length;

        return Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller.pdfPageController,
                itemCount: total,
                onPageChanged: controller.onPdfPageChanged,
                itemBuilder: (context, index) {
                  final page = controller.pdfPages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.memory(
                        page,
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            _PdfPagerControls(
              currentPage: controller.currentPdfPage.value,
              totalPages: total,
              onPreviousTap: controller.onPdfPreviousTap,
              onNextTap: controller.onPdfNextTap,
            ),
            const SizedBox(height: 6),
            // Text(
            //   '${controller.currentPdfPage.value + 1}/$total',
            //   style: AppTextStyles.drawerItem.copyWith(
            //     color: AppColors.primaryDark,
            //     fontWeight: FontWeight.w600,
            //     fontSize: 13,
            //   ),
            // ),
          ],
        );
      },
    );
  }
}

class _PdfPagerControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onPreviousTap;
  final VoidCallback onNextTap;

  const _PdfPagerControls({
    required this.currentPage,
    required this.totalPages,
    required this.onPreviousTap,
    required this.onNextTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: currentPage > 0 ? onPreviousTap : null,
          icon: const Icon(Icons.chevron_left_rounded),
          color: AppColors.primary,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.surfaceBorder),
          ),
          child: Text(
            '${currentPage + 1} / $totalPages',
            style: AppTextStyles.drawerItem.copyWith(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
        IconButton(
          onPressed: currentPage < totalPages - 1 ? onNextTap : null,
          icon: const Icon(Icons.chevron_right_rounded),
          color: AppColors.primary,
        ),
      ],
    );
  }
}
