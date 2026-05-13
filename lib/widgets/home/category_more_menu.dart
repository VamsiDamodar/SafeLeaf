import 'package:flutter/material.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/utils/app_textstyles.dart';

class CategoryMoreMenu extends StatelessWidget {
  final bool isTelugu;
  final bool isCustom;
  final VoidCallback? onRename;
  final VoidCallback? onDelete;

  const CategoryMoreMenu({
    super.key,
    required this.isTelugu,
    required this.isCustom,
    this.onRename,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      icon: Icon(
        Icons.more_vert,
        color: AppColors.primary.withOpacity(0.75),
        size: 20,
      ),
      onSelected: (value) {
        if (value == 'rename') onRename?.call();
        if (value == 'delete') onDelete?.call();
      },
      itemBuilder: (context) {
        if (!isCustom) {
          return [
            PopupMenuItem<String>(
              enabled: false,
              value: 'not_editable',
              child: Text(
                isTelugu ? 'మార్చలేరు' : 'Not editable',
                style: AppTextStyles.drawerItem.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ];
        } 
        return [
          PopupMenuItem<String>(
            value: 'rename',
            child: Row(
              children: [
                const Icon(Icons.edit_outlined, size: 18, color: AppColors.primary),
                const SizedBox(width: 10),
                Text(
                  isTelugu ? 'పేరు మార్చు' : 'Rename',
                  style: AppTextStyles.drawerItem,
                ),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'delete',
            child: Row(
              children: [
                const Icon(Icons.delete_outline, size: 18, color: AppColors.danger),
                const SizedBox(width: 10),
                Text(
                  isTelugu ? 'తొలగించు' : 'Delete',
                  style: AppTextStyles.drawerItem.copyWith(
                    color: AppColors.danger,
                  ),
                ),
              ],
            ),
          ),
        ];
      },
    );
  }
}