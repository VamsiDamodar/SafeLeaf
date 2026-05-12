import 'package:flutter/material.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/utils/app_textstyles.dart';

class LanguageToggle extends StatelessWidget {
  final bool isTelugu;
  final VoidCallback onToggle;

  const LanguageToggle({
    super.key,
    required this.isTelugu,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    // for size increase
    // final double toggleWidth = screenWidth < 360 ? 82 : 92;
    // final double toggleHeight = screenWidth < 360 ? 30 : 34;
    // final double sliderWidth = (toggleWidth - 8) / 2;

    final screenWidth = MediaQuery.of(context).size.width;
    final double toggleWidth = screenWidth < 360 ? 70 : 78;
    final double toggleHeight = screenWidth < 360 ? 26 : 30;
    final double sliderWidth = (toggleWidth - 6) / 2;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: toggleWidth,
          height: toggleHeight,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: AppColors.toggleBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.toggleBorder,
              width: 0.8,
            ),
          ),
          child: Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                alignment:
                    isTelugu ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: sliderWidth,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.toggleThumb,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: AppTextStyles.languageToggle.copyWith(
                          color: !isTelugu
                              ? AppColors.toggleActiveText
                              : AppColors.toggleInactiveText,
                          fontSize: screenWidth < 360 ? 8.5 : 9.5,
                        ),
                        child: const Text('EN'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: AppTextStyles.languageToggle.copyWith(
                          color: isTelugu
                              ? AppColors.toggleActiveText
                              : AppColors.toggleInactiveText,
                          fontSize: screenWidth < 360 ? 8.5 : 9.5,
                        ),
                        child: const Text('తె'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}