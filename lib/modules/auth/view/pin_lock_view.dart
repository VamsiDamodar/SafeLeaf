import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeleaf/modules/auth/viewmodel/pin_lock_controller.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/widgets/createpin/pin_indicators.dart';
import 'package:safeleaf/widgets/createpin/pinkeypad.dart';

class PinLockView extends GetView<PinLockController> {
  const PinLockView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isShort = constraints.maxHeight < 700;
            final horizontalPadding = constraints.maxWidth * 0.06;
            final keypadWidth = constraints.maxWidth > 430
                ? 360.0
                : constraints.maxWidth - (horizontalPadding * 2);

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding.clamp(20.0, 28.0).toDouble(),
                    vertical: isShort ? 16 : 24,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 430),
                      child: Column(
                        children: [
                          SizedBox(height: isShort ? 28 : 42),
                          _LockHero(isShort: isShort),
                          SizedBox(height: isShort ? 18 : 26),
                          Obx(
                            () => Column(
                              children: [
                                Text(
                                  controller.title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: isShort ? 20 : 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  controller.subtitle,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: controller.showError.value
                                        ? Colors.red
                                        : AppColors.primaryDark.withValues(
                                            alpha: 0.64,
                                          ),
                                    fontSize: 12,
                                    height: 1.45,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: isShort ? 22 : 32),
                          Obx(
                            () => PinDotsIndicator(
                              length: PinLockController.pinLength,
                              filledDots: controller.filledDots,
                              hasError: controller.showError.value,
                              shakeKey: controller.shakeKey.value,
                            ),
                          ),
                          SizedBox(height: isShort ? 22 : 34),
                          SizedBox(
                            width: keypadWidth,
                            child: Obx(
                              () => PinKeypad(
                                isCompact: isShort,
                                onNumberPressed: controller.onNumberPressed,
                                onDeletePressed: controller.onDeletePressed,
                                showBiometricButton: controller.isBiometricEnabled.value,
                                onBiometricPressed: controller.authenticateWithBiometric,
                              ),
                            ),
                          ),
                          SizedBox(height: isShort ? 14 : 20),
                          Obx(
                            () => AnimatedOpacity(
                              opacity: controller.isUnlocking.value ? 1 : 0,
                              duration: const Duration(milliseconds: 150),
                              child: const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LockHero extends StatelessWidget {
  final bool isShort;

  const _LockHero({required this.isShort});

  @override
  Widget build(BuildContext context) {
    final size = isShort ? 68.0 : 78.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(
        Icons.lock_open_rounded,
        size: isShort ? 34 : 40,
        color: AppColors.primary,
      ),
    );
  }
}