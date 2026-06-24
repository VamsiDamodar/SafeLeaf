import 'package:flutter/material.dart';
import 'package:safeleaf/data/models/home_category_model.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/utils/app_textstyles.dart';

class SavingCategoryDropdown extends StatelessWidget {
  final bool isLoading;
  final bool isOpen;
  final CategoryModel? selectedCategory;
  final String searchQuery;
  final List<CategoryModel> categories;
  final VoidCallback onToggle;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<CategoryModel> onSelected;

  const SavingCategoryDropdown({
    super.key,
    required this.isLoading,
    required this.isOpen,
    required this.selectedCategory,
    required this.searchQuery,
    required this.categories,
    required this.onToggle,
    required this.onSearchChanged,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: AppTextStyles.drawerItem.copyWith(
            color: AppColors.primaryDark,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Search and select a category',
          style: AppTextStyles.drawerFooter.copyWith(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isOpen ? AppColors.primary : AppColors.primary.withOpacity(.25),
                width: isOpen ? 1.6 : 1.0,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedCategory?.name ?? 'Search or select category',
                    style: AppTextStyles.drawerItem.copyWith(
                      color: selectedCategory == null
                          ? AppColors.textSecondary
                          : AppColors.primaryDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
                Icon(
                  isOpen ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.primaryDark,
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.cardBorder),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.04),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
                    child: TextField(
                      onChanged: onSearchChanged,
                      decoration: InputDecoration(
                        isDense: true,
                        prefixIcon: const Icon(Icons.search_rounded),
                        hintText: 'Search categories...',
                        hintStyle: AppTextStyles.drawerFooter.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 260),
                    child: isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(24),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          )
                        : categories.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(18),
                            child: Text(
                              searchQuery.trim().isEmpty
                                  ? 'No categories available'
                                  : 'No matching categories',
                              style: AppTextStyles.drawerFooter.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                            itemCount: categories.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 4),
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              final isSelected = selectedCategory?.id == category.id;
                              return ListTile(
                                dense: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                leading: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: AppColors.iconBackground,
                                  child: Icon(
                                    category.icon,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                ),
                                title: Text(
                                  category.name,
                                  style: AppTextStyles.drawerItem.copyWith(
                                    color: AppColors.primaryDark,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  category.isCustom ? 'Custom category' : category.nameTelugu,
                                  style: AppTextStyles.drawerFooter.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                trailing: isSelected
                                    ? const Icon(
                                        Icons.check_circle_rounded,
                                        color: AppColors.primary,
                                      )
                                    : null,
                                onTap: () => onSelected(category),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
          crossFadeState:
              isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 180),
          sizeCurve: Curves.easeOut,
        ),
      ],
    );
  }
}
