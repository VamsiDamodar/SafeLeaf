import 'package:flutter/material.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/utils/app_textstyles.dart';

class EnhanceEditTools extends StatelessWidget {
  final VoidCallback onRotateTap;
  final VoidCallback onCropTap;
  final VoidCallback onDeleteTap;

  const EnhanceEditTools({
    super.key,
    required this.onRotateTap,
    required this.onCropTap,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _ToolButton(icon: Icons.rotate_right_rounded, label: 'Rotate', onTap: onRotateTap),
        _ToolButton(icon: Icons.crop_rounded, label: 'Crop', onTap: onCropTap),
        _ToolButton(icon: Icons.delete_outline_rounded, label: 'Delete', onTap: onDeleteTap),
      ],
    );
  }
}

class _ToolButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ToolButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 34),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppTextStyles.drawerItem.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}