import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeleaf/modules/saving/save_success_viewmodel.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/utils/app_textstyles.dart';

class SaveSuccessView extends GetView<SaveSuccessViewModel> {
  const SaveSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Obx(() {
          final isComplete = controller.isComplete.value;
          final percent = (controller.progress.value * 100).round();

          return Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 650),
                curve: Curves.easeOutCubic,
                alignment: isComplete
                    ? const Alignment(0, -0.55)
                    : Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _ProgressStatus(
                        percent: percent,
                        isComplete: isComplete,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        isComplete
                            ? 'Document saved successfully'
                            : 'Saving your document',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.drawerHeaderTitle.copyWith(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        controller.fileName.value.isEmpty
                            ? 'We are preparing your file in SafeLeaf.'
                            : controller.fileName.value,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.drawerItem.copyWith(
                          color: AppColors.primaryLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 24,
                right: 24,
                bottom: 24,
                child: IgnorePointer(
                  ignoring: !isComplete,
                  child: AnimatedSlide(
                    duration: const Duration(milliseconds: 550),
                    curve: Curves.easeOutCubic,
                    offset: isComplete ? Offset.zero : const Offset(0, 1.5),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 350),
                      opacity: isComplete ? 1 : 0,
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: OutlinedButton.icon(
                              onPressed: controller.onShareTap,
                              icon: const Icon(Icons.share_outlined),
                              label: const Text('Share Document'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(
                                  color: Colors.white,
                                  width: 1.3,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton.icon(
                              onPressed: controller.onViewDocumentTap,
                              icon: const Icon(Icons.visibility_outlined),
                              label: const Text('View Document'),
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.primaryDark,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
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
            ],
          );
        }),
      ),
    );
  }
}

class _ProgressStatus extends StatelessWidget {
  const _ProgressStatus({required this.percent, required this.isComplete});

  final int percent;
  final bool isComplete;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: CircularProgressIndicator(
            value: percent / 100,
            strokeWidth: 10,
            backgroundColor: Colors.white.withOpacity(0.25),
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.primaryLight,
            ),
          ),
        ),
        Container(
          width: 104,
          height: 104,
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Icon(
              isComplete ? Icons.check_rounded : Icons.hourglass_top_rounded,
              key: ValueKey(isComplete),
              size: 52,
              color: isComplete ? AppColors.safe : AppColors.primary,
            ),
          ),
        ),
        Positioned(
          bottom: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primaryDark,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '$percent%',
              style: AppTextStyles.drawerFooter.copyWith(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
