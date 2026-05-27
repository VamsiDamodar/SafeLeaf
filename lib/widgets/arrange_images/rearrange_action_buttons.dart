import 'package:flutter/material.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/utils/app_textstyles.dart';

class RearrangeActionButtons extends StatelessWidget {
  final double gap;
  final double buttonHeight;
  final VoidCallback onAddMoreTap;
  final VoidCallback onNextTap;

  const RearrangeActionButtons({
    super.key,
    required this.gap,
    required this.buttonHeight,
    required this.onAddMoreTap,
    required this.onNextTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: buttonHeight,
            child: OutlinedButton.icon(
              onPressed: onAddMoreTap,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add More'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(
                  color: AppColors.primary,
                  width: 1.2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: AppTextStyles.drawerItem.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: gap),
        Expanded(
          child: SizedBox(
            height: buttonHeight,
            child: ElevatedButton(
              onPressed: onNextTap,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: AppTextStyles.drawerItem.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: const Text('Next'),
            ),
          ),
        ),
      ],
    );
  }
}