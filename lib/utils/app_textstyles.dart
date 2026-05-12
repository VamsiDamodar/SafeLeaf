import 'package:flutter/material.dart';
import 'package:safeleaf/utils/app_colors.dart';

class AppTextStyles {
  static const splashAppName = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  static const splashTagline = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryLight,
    letterSpacing: 2.0,
  );

  static const splashLoading = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: Color(0x9995D5B2),
    letterSpacing: 0.5,
  );

  // ─── Extra reusable styles ─────────────────────────────

  static const drawerHeaderTitle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: 0.3,
  );

  static const drawerHeaderSubtitle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: Colors.white70,
    letterSpacing: 0.4,
  );

  static const drawerSectionTitle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    letterSpacing: 0.8,
  );

  static const drawerItem = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryDark,
    letterSpacing: 0.2,
  );

  static const drawerItemActive = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    letterSpacing: 0.2,
  );

  static const drawerFooter = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryDark,
    letterSpacing: 0.3,
  );
  static const languageToggle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.1,
  );
}