import 'package:flutter/material.dart';
import 'package:safeleaf/utils/app_colors.dart';

class HomeHeader extends StatelessWidget {
  final bool isCompact;

  const HomeHeader({super.key, required this.isCompact});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back,',
            style: TextStyle(
              color: AppColors.accent,
              fontSize: isCompact ? 13 : 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Your Vault is Secure \u{1F512}',
            style: TextStyle(
              color: AppColors.primaryDark,
              fontSize: isCompact ? 20 : 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'All documents are stored offline',
            style: TextStyle(
              color: const Color(0xA31B4332),
              fontSize: isCompact ? 10 : 12,
              fontWeight: FontWeight.w400,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
