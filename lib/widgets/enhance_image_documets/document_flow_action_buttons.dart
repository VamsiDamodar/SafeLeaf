import 'package:flutter/material.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/utils/app_textstyles.dart';

class DocumentFlowActionButtons extends StatelessWidget {
  final double gap;
  final double buttonHeight;
  final String leftLabel;
  final String rightLabel;
  final IconData leftIcon;
  final IconData rightIcon;
  final VoidCallback onLeftTap;
  final VoidCallback onRightTap;

  const DocumentFlowActionButtons({
    super.key,
    required this.gap,
    required this.buttonHeight,
    required this.leftLabel,
    required this.rightLabel,
    required this.leftIcon,
    required this.rightIcon,
    required this.onLeftTap,
    required this.onRightTap,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTextStyles.drawerItem.copyWith(
      fontWeight: FontWeight.w700,
    );

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: buttonHeight,
            child: OutlinedButton.icon(
              onPressed: onLeftTap,
              icon: Icon(leftIcon),
              label: Text(leftLabel),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary, width: 1.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                textStyle: textStyle,
              ),
            ),
          ),
        ),
        SizedBox(width: gap),
        Expanded(
          child: SizedBox(
            height: buttonHeight,
            child: ElevatedButton.icon(
              onPressed: onRightTap,
              label: Text(rightLabel),
              icon: Icon(rightIcon),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                textStyle: textStyle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}