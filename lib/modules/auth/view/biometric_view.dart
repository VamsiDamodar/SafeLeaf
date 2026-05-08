import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeleaf/modules/auth/viewmodel/biometric_setup_controller.dart';
import 'package:safeleaf/utils/app_colors.dart';

class BiometricSetupView extends GetView<BiometricSetupController> {
  const BiometricSetupView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.06,
            vertical: isSmallScreen ? 16 : 24,
          ),
          child: Column(
            children: [
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildStepDot(isActive: true),
                    const SizedBox(width: 6),
                    _buildStepDot(isActive: true),
                  ],
                ),
              ),

              SizedBox(height: isSmallScreen ? 32 : 48),

              // ── Fingerprint Icon ──
              Container(
                width: isSmallScreen ? 64 : 72,
                height: isSmallScreen ? 64 : 72,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.fingerprint,
                    size: isSmallScreen ? 36 : 42,
                    color: AppColors.primary,
                  ),
                ),
              ),

              SizedBox(height: isSmallScreen ? 20 : 28),

              // ── Title + Subtitle ──
              const Text(
                'Enable Biometric?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Unlock faster with your\nfingerprint or face',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.accent,
                  height: 1.5,
                ),
              ),

              const Spacer(),

              // ── Action Buttons ──
              Column(
                children: [
                  _buildOptionCard(
                    icon: Icons.fingerprint,
                    title: 'Enable Biometric',
                    subtitle: 'Fingerprint / Face unlock',
                    onTap: controller.enableBiometric,
                    isPrimary: true,
                  ),
                  const SizedBox(height: 12),
                  _buildOptionCard(
                    icon: Icons.close_rounded,
                    title: 'Skip for now',
                    subtitle: 'Use PIN only',
                    onTap: controller.skipBiometric,
                    isPrimary: false,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Text(
                'You can change this later in Settings',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.accent.withOpacity(0.7),
                ),
              ),

              SizedBox(height: isSmallScreen ? 16 : 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepDot({required bool isActive}) {
    return Container(
      width: 24,
      height: 4,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.primaryLight.withOpacity(0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFFE8F5E9) : Colors.white,
          border: Border.all(
            color: isPrimary
                ? AppColors.primaryLight.withOpacity(0.5)
                : AppColors.surfaceBorder,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isPrimary ? Colors.white : AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isPrimary ? AppColors.primary : AppColors.accent,
                size: 24,
              ),
            ),

            const SizedBox(width: 14),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.accent.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),

            // Arrow
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.accent.withOpacity(0.6),
            ),
          ],
        ),
      ),
    );
  }
}