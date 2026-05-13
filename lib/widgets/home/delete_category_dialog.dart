import 'package:flutter/material.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/utils/app_textstyles.dart';

class DeleteCategoryDialog extends StatelessWidget {
  final bool isTelugu;
  final String categoryName;
  final bool hasDocuments;
  final int documentCount;
  final VoidCallback onDelete;

  const DeleteCategoryDialog({
    super.key,
    required this.isTelugu,
    required this.categoryName,
    required this.hasDocuments,
    required this.documentCount,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 78,
              width: 78,
              decoration: BoxDecoration(
                color: AppColors.danger.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.danger,
                size: 34,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              isTelugu ? 'కేటగిరీ తొలగించు' : 'Delete Category',
              style: AppTextStyles.drawerHeaderTitle.copyWith(
                color: AppColors.danger,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 14),

            Text(
              hasDocuments
                  ? (isTelugu
                      ? '"$categoryName" కేటగిరీలో $documentCount పత్రాలు ఉన్నాయి.\nవీటిని Other లోకి మార్చి కేటగిరీని తొలగించాలా?'
                      : 'Are you sure you want to delete "$categoryName"?\n$documentCount documents will be moved to Other.')
                  : (isTelugu
                      ? '"$categoryName" కేటగిరీని నిజంగా తొలగించాలా?'
                      : 'Are you sure you want to delete "$categoryName" category?'),
              style: AppTextStyles.drawerItem.copyWith(
                color: AppColors.primaryDark,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      side: const BorderSide(color: AppColors.surfaceBorder),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      isTelugu ? 'రద్దు' : 'Cancel',
                      style: AppTextStyles.drawerItem.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onDelete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.danger,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      isTelugu ? 'తొలగించు' : 'Delete',
                      style: AppTextStyles.drawerItem.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}