import 'package:flutter/material.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/utils/app_textstyles.dart';

class SavingFileNameField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const SavingFileNameField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'File Name',
          style: AppTextStyles.drawerItem.copyWith(
            color: AppColors.primaryDark,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          onChanged: onChanged,
          style: AppTextStyles.drawerItem.copyWith(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.insert_drive_file_outlined,
              color: AppColors.textSecondary,
            ),
            filled: true,
            fillColor: AppColors.surface,
            hintText: 'Enter file name',
            hintStyle: AppTextStyles.drawerFooter.copyWith(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
