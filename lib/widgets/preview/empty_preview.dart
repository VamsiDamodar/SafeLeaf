import 'package:flutter/material.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/utils/app_textstyles.dart';

class EmptyPreview extends StatelessWidget {
  final VoidCallback onChangeFileTap;

  const EmptyPreview({super.key, required this.onChangeFileTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: onChangeFileTap,
        child: Text(
          'Choose a document',
          style: AppTextStyles.drawerItem.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
