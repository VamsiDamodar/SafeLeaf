import 'package:flutter/material.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/utils/app_textstyles.dart';

class EnhancePageControls extends StatelessWidget {
  final int currentIndex;
  final int totalCount;
  final VoidCallback onPreviousTap;
  final VoidCallback onNextTap;

  const EnhancePageControls({
    super.key,
    required this.currentIndex,
    required this.totalCount,
    required this.onPreviousTap,
    required this.onNextTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: currentIndex == 0 ? null : onPreviousTap,
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.primary,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '${currentIndex + 1}/$totalCount',
            style: AppTextStyles.drawerItem.copyWith(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        IconButton(
          onPressed: currentIndex == totalCount - 1 ? null : onNextTap,
          icon: const Icon(Icons.arrow_forward_rounded),
          color: AppColors.primary,
        ),
      ],
    );
  }
}