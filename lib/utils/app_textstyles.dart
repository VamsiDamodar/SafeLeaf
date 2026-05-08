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
    color: Color(0x9995D5B2), // primaryLight with opacity
    letterSpacing: 0.5,
  );
}