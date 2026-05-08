import 'package:flutter/material.dart';
import 'package:safeleaf/utils/app_colors.dart';

/// Decorative background circles — pure visual, no logic
class SplashBgCircles extends StatelessWidget {
  const SplashBgCircles({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        // Top-right large circle
        Positioned(
          top: -size.width * 0.30,
          right: -size.width * 0.25,
          child: _Circle(
            diameter: size.width * 0.75,
            color: AppColors.accent.withOpacity(0.13),
          ),
        ),
        // Bottom-left medium circle
        Positioned(
          bottom: size.height * 0.05,
          left: -size.width * 0.20,
          child: _Circle(
            diameter: size.width * 0.55,
            color: AppColors.primaryLight.withOpacity(0.09),
          ),
        ),
        // Bottom-right small circle
        Positioned(
          bottom: size.height * 0.20,
          right: size.width * 0.04,
          child: _Circle(
            diameter: size.width * 0.28,
            color: AppColors.accent.withOpacity(0.07),
          ),
        ),
      ],
    );
  }
}

class _Circle extends StatelessWidget {
  final double diameter;
  final Color color;
  const _Circle({required this.diameter, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}