import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeleaf/modules/saving/saving_viewmodel.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/widgets/common/safeleaf_page_app_bar.dart';
import 'package:safeleaf/widgets/saving/saving_action_buttons.dart';
import 'package:safeleaf/widgets/saving/saving_category_dropdown.dart';
import 'package:safeleaf/widgets/saving/saving_extension_dropdown.dart';
import 'package:safeleaf/widgets/saving/saving_file_name_field.dart';
import 'package:safeleaf/widgets/saving/saving_selected_file_preview.dart';

class SavingView extends GetView<SavingViewModel> {
  const SavingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: SafeLeafPageAppBar(
        title: 'Saving',
        onBackTap: controller.onBackTap,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            final horizontalPadding = (width * 0.06).clamp(16.0, 24.0).toDouble();
            final sectionGap = (height * 0.02).clamp(14.0, 20.0).toDouble();

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                18,
                horizontalPadding,
                20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Obx(
                    () => SavingSelectedFilePreview(
                      fileName: controller.primaryFileName,
                      fileSizeText: controller.readableSize,
                      extension: controller.primaryExtension,
                    ),
                  ),
                  SizedBox(height: sectionGap),
                  SavingFileNameField(
                    controller: controller.fileNameController,
                    onChanged: controller.onFileNameChanged,
                  ),
                  SizedBox(height: sectionGap),
                  Obx(
                    () => SavingCategoryDropdown(
                      isLoading: controller.isLoadingCategories.value,
                      isOpen: controller.isCategoryDropdownOpen.value,
                      selectedCategory: controller.selectedCategory.value,
                      searchQuery: controller.categorySearchQuery.value,
                      categories: controller.filteredCategories,
                      onToggle: controller.onToggleCategoryDropdown,
                      onSearchChanged: controller.onCategoryQueryChanged,
                      onSelected: controller.onCategorySelected,
                    ),
                  ),
                  SizedBox(height: sectionGap),
                  Obx(
                    () => SavingExtensionDropdown(
                      selectedExtension: controller.selectedExtension.value,
                      extensions: controller.extensionOptions,
                      onChanged: controller.onExtensionSelected,
                    ),
                  ),
                  SizedBox(height: sectionGap * 1.2),
                  Obx(
                    () => SavingActionButtons(
                      onBackTap: controller.onBackTap,
                      onContinueTap: controller.onContinueTap,
                      continueEnabled: controller.canContinue,
                      isSaving: controller.isSaving.value,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
