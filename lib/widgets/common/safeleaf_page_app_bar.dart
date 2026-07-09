import 'package:flutter/material.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/utils/app_textstyles.dart';

class SafeLeafPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBackTap;

  const SafeLeafPageAppBar({
    super.key,
    required this.title,
    required this.onBackTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final appBarTitleSize = (screenWidth * 0.043).clamp(15.0, 20.0).toDouble();
    final iconSize = (screenWidth * 0.075).clamp(26.0, 32.0).toDouble();

    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.surface,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        onPressed: onBackTap,
        icon: Icon(
          Icons.arrow_back_rounded,
          color: AppColors.primaryDark,
          size: iconSize,
        ),
      ),
      title: Text(
        title,
        style: AppTextStyles.drawerItem.copyWith(
          color: AppColors.primaryDark,
          fontWeight: FontWeight.w600,
          fontSize: appBarTitleSize,
        ),
      ),
      actions: [
        SizedBox(width: screenWidth * 0.12),
      ],
    );
  }
}
