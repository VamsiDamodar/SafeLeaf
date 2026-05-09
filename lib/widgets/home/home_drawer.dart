// lib/widgets/home/home_drawer.dart

import 'package:flutter/material.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/utils/app_textstyles.dart';
import 'package:safeleaf/widgets/splash/safeleaf_icon.dart';

class HomeDrawer extends StatelessWidget {
  final bool isTelugu;
  final bool biometricEnabled;
  final String selectedItem;
  final ValueChanged<bool> onBiometricChanged;
  final VoidCallback onHomeTap;
  final VoidCallback onMyDocumentsTap;
  final VoidCallback onScanTap;
  final VoidCallback onLanguageTap;
  final VoidCallback onAboutTap;

  const HomeDrawer({
    super.key,
    required this.isTelugu,
    required this.biometricEnabled,
    required this.selectedItem,
    required this.onBiometricChanged,
    required this.onHomeTap,
    required this.onMyDocumentsTap,
    required this.onScanTap,
    required this.onLanguageTap,
    required this.onAboutTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 304,
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(0, 14, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('MAIN'),
                    _buildDrawerItem(
                      icon: Icons.home_rounded,
                      title: 'Home',
                      selected: selectedItem == 'home',
                      onTap: onHomeTap,
                    ),
                    _buildDrawerItem(
                      icon: Icons.folder_rounded,
                      title: 'My Documents',
                      selected: selectedItem == 'documents',
                      onTap: onMyDocumentsTap,
                    ),
                    _buildDrawerItem(
                      icon: Icons.document_scanner_rounded,
                      title: 'Scan Document',
                      selected: selectedItem == 'scan',
                      onTap: onScanTap,
                    ),
                    const SizedBox(height: 10),
                    _buildSectionTitle('PREFERENCES'),
                    _buildBiometricTile(),
                    _buildDrawerItem(
                      icon: Icons.language_rounded,
                      title: 'Language',
                      subtitle: isTelugu ? 'తెలుగు' : 'English',
                      selected: selectedItem == 'language',
                      onTap: onLanguageTap,
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              height: 12,
              thickness: 1,
              color: AppColors.surfaceBorder,
            ),
            _buildDrawerItem(
              icon: Icons.info_outline_rounded,
              title: 'About',
              selected: selectedItem == 'about',
              onTap: onAboutTap,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Version 1.0.0',
                  style: AppTextStyles.drawerFooter.copyWith(
                    color: AppColors.primaryDark.withValues(alpha: 0.58),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
  return Container(
    
    width: double.infinity,
    constraints: const BoxConstraints(minHeight: 180),
    padding: const EdgeInsets.fromLTRB(18, 34, 18, 30),
    color: AppColors.primary,
    child: Row(
      children: [
        const SafeLeafIcon(size: 58),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SafeLeaf',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.drawerHeaderTitle.copyWith(
                  fontSize: 24,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                'Scan • Track • Stay Safe',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.drawerHeaderSubtitle.copyWith(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.72),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
      child: Text(
        title,
        style: AppTextStyles.drawerSectionTitle.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildBiometricTile() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    child: Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.fingerprint_rounded,
          color: AppColors.primary,
        ),
        title: Text(
          'Biometric Lock',
          style: AppTextStyles.drawerItem.copyWith(
            color: AppColors.primaryDark,
          ),
        ),
        trailing: Switch(
          value: biometricEnabled,
          onChanged: onBiometricChanged,
          activeColor: AppColors.accent,
        ),
        onTap: () => onBiometricChanged(!biometricEnabled),
      ),
    ),
  );
}

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final foreground = selected ? AppColors.primary : AppColors.primaryDark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: Material(
        color: selected
            ? AppColors.primaryLight.withValues(alpha: 0.18)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            constraints: BoxConstraints(minHeight: subtitle == null ? 58 : 66),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: selected
                  ? Border.all(
                      color: AppColors.primaryLight.withValues(alpha: 0.45),
                    )
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: foreground,
                  size: 26,
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: (selected
                                ? AppTextStyles.drawerItemActive
                                : AppTextStyles.drawerItem)
                            .copyWith(
                          fontSize: 16,
                          color: foreground,
                          height: 1.2,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.splashLoading.copyWith(
                            fontSize: 12,
                            color:
                                AppColors.primaryDark.withValues(alpha: 0.58),
                            letterSpacing: 0.1,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
