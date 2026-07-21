import 'package:flutter/material.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/utils/app_textstyles.dart';

class SavingActionButtons extends StatelessWidget {
  final VoidCallback onBackTap;
  final VoidCallback onContinueTap;
  final bool continueEnabled;
  final bool isSaving;

  const SavingActionButtons({
    super.key,
    required this.onBackTap,
    required this.onContinueTap,
    required this.continueEnabled,
    required this.isSaving,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onBackTap,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: AppColors.primary, width: 1.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Back',
              style: AppTextStyles.drawerItem.copyWith(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: ElevatedButton(
            onPressed: isSaving
                ? null
                : () {
                    onContinueTap();
                  },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 0,
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.primary.withOpacity(.35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Continue',
                    style: AppTextStyles.drawerItem.copyWith(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
