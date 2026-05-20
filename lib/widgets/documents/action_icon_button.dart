import 'package:flutter/material.dart';
import 'package:safeleaf/utils/app_colors.dart';


class ActionIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const ActionIconButton({
    super.key,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Icon(
          icon,
          size: 20,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
