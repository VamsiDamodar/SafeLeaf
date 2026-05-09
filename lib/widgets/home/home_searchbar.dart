import 'package:flutter/material.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/utils/app_textstyles.dart';

class HomeSearchBar extends StatelessWidget {
  final Function(String) onChanged;

  const HomeSearchBar({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        onChanged: onChanged,
        style: AppTextStyles.splashTagline.copyWith(
          fontSize: 12,
          color: AppColors.primaryDark,
          letterSpacing: 0.3,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Search categories...',
          hintStyle: AppTextStyles.splashLoading.copyWith(
            fontSize: 13,
            color: AppColors.primaryDark.withOpacity(0.45),
            letterSpacing: 0.3,
          ),

          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.primary,
          ),

          filled: true,
          fillColor: AppColors.surface,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AppColors.surfaceBorder,
            ),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AppColors.surfaceBorder,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AppColors.accent,
              width: 1.8,
            ),
          ),
        ),
      ),
    );
  }
}