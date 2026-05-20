import 'package:flutter/material.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/utils/app_textstyles.dart';

class DocumentSecureBanner extends StatelessWidget {
  const DocumentSecureBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 235, 244, 237),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.surfaceBorder,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.verified_rounded,
            color: AppColors.primary,
            size: 25,
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your documents are secure',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.drawerItem.copyWith(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'All files are protected by on your device',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.drawerFooter.copyWith(
                    color: const Color(0xFF5E6272),
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    height: 1.15,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),
          const Icon(
            Icons.lock_outline_rounded,
            color: AppColors.primary,
            size: 25,
          ),
        ],
      ),
    );
  }
}