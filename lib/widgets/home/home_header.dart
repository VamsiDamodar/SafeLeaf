import 'package:flutter/material.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/utils/app_textstyles.dart';

class HomeCategoryHeader extends StatelessWidget {
  final bool isTelugu;
  final int categoryCount;
  final bool isGridView;
  final VoidCallback onAddCategoryTap;
  final VoidCallback onToggleViewTap;

  const HomeCategoryHeader({
    super.key,
    required this.isTelugu,
    required this.categoryCount,
    required this.isGridView,
    required this.onAddCategoryTap,
    required this.onToggleViewTap,
  });

  @override
  Widget build(BuildContext context) {
    final title = isTelugu ? 'కేటగిరీలు' : 'Categories';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: title,
                    style: AppTextStyles.drawerHeaderTitle.copyWith(
                      fontSize: 17,
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: ' ($categoryCount)',
                    style: AppTextStyles.drawerItem.copyWith(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// Add Category Button
          _ActionIconButton(
            icon: Icons.add_rounded,
            onTap: onAddCategoryTap,
            tooltip: isTelugu ? 'కేటగిరీ జోడించు' : 'Add Category',
          ),

          const SizedBox(width: 8),

          /// Grid/List Toggle
          _ActionIconButton(
            icon: isGridView
                ? Icons.view_list_rounded
                : Icons.grid_view_rounded,
            onTap: onToggleViewTap,
            tooltip: isGridView
                ? (isTelugu ? 'లిస్ట్ వ్యూ' : 'List View')
                : (isTelugu ? 'గ్రిడ్ వ్యూ' : 'Grid View'),
          ),
        ],
      ),
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  const _ActionIconButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.surfaceBorder,
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              size: 20,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}