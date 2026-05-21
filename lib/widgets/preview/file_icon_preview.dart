import 'package:flutter/material.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/utils/app_textstyles.dart';

class FileIconPreview extends StatelessWidget {
  final String extension;
  final double screenWidth;

  const FileIconPreview({
    super.key,
    required this.extension,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    final icon = extension == 'pdf'
        ? Icons.picture_as_pdf_rounded
        : Icons.description_rounded;

    final iconBoxSize = (screenWidth * 0.22).clamp(76.0, 104.0).toDouble();
    final iconSize = (screenWidth * 0.12).clamp(42.0, 58.0).toDouble();
    final labelSize = (screenWidth * 0.042).clamp(15.0, 19.0).toDouble();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: iconBoxSize,
          height: iconBoxSize,
          decoration: const BoxDecoration(
            color: AppColors.iconBackground,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: iconSize,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          extension.toUpperCase(),
          style: AppTextStyles.drawerHeaderTitle.copyWith(
            color: AppColors.primaryDark,
            fontSize: labelSize,
          ),
        ),
      ],
    );
  }
}
