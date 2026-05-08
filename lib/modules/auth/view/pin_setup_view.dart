import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeleaf/modules/auth/viewmodel/pin_setup_controller.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/widgets/createpin/pin_indicators.dart';
import 'package:safeleaf/widgets/createpin/pinkeypad.dart';

class PinSetupView extends GetView<PinSetupController> {
  const PinSetupView({super.key});

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
                          _StepHeader(isShort: isShort),
                          SizedBox(height: isShort ? 28 : 42),
                          _PinHero(isShort: isShort),
                          SizedBox(height: isShort ? 18 : 26),
                          Obx(
                            () => AnimatedSwitcher(
                              duration: const Duration(milliseconds: 180),
                              child: Column(
                                key: ValueKey(
                                  '${controller.isConfirmStep.value}_${controller.showError.value}',
                                ),
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
                          ),
                          SizedBox(height: isShort ? 22 : 32),
                          Obx(
                            () => PinDotsIndicator(
                              length: PinSetupController.pinLength,
                              filledDots: controller.filledDots,
                              hasError: controller.showError.value,
                              shakeKey: controller.shakeKey.value,
                            ),
                          ),
                          SizedBox(height: isShort ? 22 : 34),
                          SizedBox(
                            width: keypadWidth,
                            child: PinKeypad(
                              isCompact: isShort,
                              onNumberPressed: controller.onNumberPressed,
                              onDeletePressed: controller.onDeletePressed,
                            ),
                          ),
                          SizedBox(height: isShort ? 14 : 20),
                          Obx(
                            () => AnimatedOpacity(
                              opacity: controller.isSaving.value ? 1 : 0,
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

class _StepHeader extends StatelessWidget {
  final bool isShort;

  const _StepHeader({required this.isShort});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 68),
        const Spacer(),
        const Row(
          children: [
            _StepDot(isActive: true),
            SizedBox(width: 6),
            _StepDot(isActive: false),
          ],
        ),
        const Spacer(),
        Text(
          'Step 1 of 2',
          style: TextStyle(
            color: AppColors.accent.withValues(alpha: 0.78),
            fontSize: isShort ? 11 : 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _StepDot extends StatelessWidget {
  final bool isActive;

  const _StepDot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 4,
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primary
            : AppColors.primaryLight.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _PinHero extends StatelessWidget {
  final bool isShort;

  const _PinHero({required this.isShort});

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
        Icons.lock_outline_rounded,
        size: isShort ? 34 : 40,
        color: AppColors.primary,
      ),
    );
  }
}