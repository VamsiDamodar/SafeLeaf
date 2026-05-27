import 'dart:io';

import 'package:flutter/material.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/utils/app_textstyles.dart';

class RearrangeImageCard extends StatelessWidget {
  final File file;
  final int orderNumber;
  final String title;
  final String sizeText;

  const RearrangeImageCard({
    super.key,
    required this.file,
    required this.orderNumber,
    required this.title,
    required this.sizeText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 3),
            color: Colors.black.withOpacity(0.07),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final imageHeight = (constraints.maxWidth * 0.78)
                      .clamp(60.0, 145.0)
                      .toDouble();

                  return Container(
                    width: double.infinity,
                    height: imageHeight,
                    padding: const EdgeInsets.all(6),
                    color: AppColors.cardBackground,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.file(file, fit: BoxFit.cover),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.drawerItem.copyWith(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 1, 10, 10),
                child: Text(
                  sizeText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.drawerItem.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 4,
            top: 4,
            child: Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Text(
                '$orderNumber',
                style: AppTextStyles.drawerItem.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}