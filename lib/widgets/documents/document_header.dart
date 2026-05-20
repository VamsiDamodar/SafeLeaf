import 'package:flutter/material.dart';
import 'package:safeleaf/data/models/home_category_model.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/utils/app_textstyles.dart';

class DocumentHeader extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback? onSearchTap;
  final VoidCallback? onFilterTap;

  const DocumentHeader({
    super.key,
    required this.category,
    this.onSearchTap,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.iconBackground.withOpacity(0.72),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.surfaceBorder.withOpacity(0.65),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryDark.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(
              category.icon,
              size: 25,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.drawerHeaderTitle.copyWith(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${category.documentCount} Documents',
                  style: AppTextStyles.drawerFooter.copyWith(
                    color: const Color(0xFF5E6272),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          _HeaderActionButton(
            icon: Icons.search_rounded,
            onTap: onSearchTap,
          ),
          const SizedBox(width: 8),
          _HeaderActionButton(
            icon: Icons.filter_list_rounded,
            onTap: onFilterTap,
          ),
        ],
      ),
    );
  }
}

class _HeaderActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _HeaderActionButton({
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.cardBorder,
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            size: 25,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
