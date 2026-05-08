import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeleaf/modules/splash/viewmodel/splash_viewmodel.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/utils/app_textstyles.dart';
import 'package:safeleaf/widgets/splash/safeleaf_icon.dart';
import 'package:safeleaf/widgets/splash/splash_progress_bar.dart';
import 'package:safeleaf/widgets/splash/splash_bg_circle.dart';
import 'package:safeleaf/core/constants/strings.dart';

/// SplashView — Pure UI, zero business logic.
/// All logic lives in SplashController.
class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          // ── Decorative background circles ──────────────────────
          const SplashBgCircles(),

          // ── Main centered content ──────────────────────────────
          Center(
            child: Obx(() => AnimatedOpacity(
              opacity: controller.showContent.value ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOut,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // App Icon
                  const SafeLeafIcon(size: 100),

                  const SizedBox(height: 28),

                  // App Name
                  const Text(
                    splashScreenStrings.appName,
                    style: AppTextStyles.splashAppName,
                  ),

                  const SizedBox(height: 6),

                  // Tagline
                  const Text(
                    splashScreenStrings.tagline,
                    style: AppTextStyles.splashTagline,
                  ),

                  const SizedBox(height: 48),

                  // Progress bar + loading text
                  SplashProgressBar(
                    progress: controller.progressValue,
                    loadingText: controller.loadingText,
                  ),
                ],
              ),
            )),
          ),
        ],
      ),
    );
  }
}