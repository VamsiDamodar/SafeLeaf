import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/utils/app_textstyles.dart';

class SplashProgressBar extends StatelessWidget {
  final RxDouble progress;
  final RxString loadingText;

  const SplashProgressBar({
    super.key,
    required this.progress,
    required this.loadingText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Animated progress bar
        Obx(() => AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          width: 72,
          height: 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progress.value,
              backgroundColor: Colors.white.withOpacity(0.12),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
              minHeight: 3,
            ),
          ),
        )),

        const SizedBox(height: 10),

        // Loading text
        Obx(() => AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            loadingText.value,
            key: ValueKey(loadingText.value),
            style: AppTextStyles.splashLoading,
          ),
        )),
      ],
    );
  }
}