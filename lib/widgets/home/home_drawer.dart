import 'package:flutter/material.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/utils/app_textstyles.dart';
import 'package:safeleaf/widgets/splash/safeleaf_icon.dart';
import 'package:safeleaf/widgets/splash/splash_bg_circle.dart';

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
    final size = MediaQuery.of(context).size;

    final bool isSmall = size.width < 360;
    final double headerHeight = isSmall ? 190 : 210;
    final double pagePadding = isSmall ? 14 : 16;

    return Drawer(
      width: size.width,
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: Stack(
          children: [
            const Positioned.fill(
              child: ColoredBox(color: AppColors.surface),
            ),

            SizedBox(
              height: headerHeight,
              width: double.infinity,
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryDark,
                          AppColors.primary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  const SplashBgCircles(),
                ],
              ),
            ),

            Positioned(
              top: isSmall ? 10 : 12,
              right: isSmall ? 10 : 12,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: isSmall ? 36 : 40,
                    height: isSmall ? 36 : 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.14),
                      ),
                    ),
                    child: Icon(
                      Icons.chevron_left_rounded,
                      color: Colors.white,
                      size: isSmall ? 24 : 26,
                    ),
                  ),
                ),
              ),
            ),

            Column(
              children: [
                _buildHeader(context, headerHeight, isSmall),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(26),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        pagePadding,
                        pagePadding,
                        pagePadding,
                        18,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('MAIN', isSmall),
                          SizedBox(height: isSmall ? 6 : 8),

                          _buildDrawerItem(
                            context: context,
                            icon: Icons.home_rounded,
                            title: 'Home',
                            selected: selectedItem == 'home',
                            onTap: onHomeTap,
                          ),
                          SizedBox(height: isSmall ? 6 : 8),

                          _buildDrawerItem(
                            context: context,
                            icon: Icons.folder_rounded,
                            title: 'My Documents',
                            selected: selectedItem == 'documents',
                            onTap: onMyDocumentsTap,
                          ),
                          SizedBox(height: isSmall ? 4 : 6),

                          _buildDrawerItem(
                            context: context,
                            icon: Icons.document_scanner_rounded,
                            title: 'Scan Document',
                            selected: selectedItem == 'scan',
                            onTap: onScanTap,
                          ),

                          SizedBox(height: isSmall ? 14 : 16),
                          _buildSectionTitle('PREFERENCES', isSmall),
                          SizedBox(height: isSmall ? 6 : 8),

                          _buildBiometricItem(context, isSmall),
                          SizedBox(height: isSmall ? 4 : 6),

                          _buildDrawerItem(
                            context: context,
                            icon: Icons.language_rounded,
                            title: 'Language',
                            subtitle: isTelugu ? 'తెలుగు' : 'English',
                            selected: selectedItem == 'language',
                            onTap: onLanguageTap,
                          ),

                          SizedBox(height: isSmall ? 14 : 16),
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: AppColors.surfaceBorder.withOpacity(0.9),
                          ),
                          SizedBox(height: isSmall ? 12 : 14),

                          _buildDrawerItem(
                            context: context,
                            icon: Icons.info_outline_rounded,
                            title: 'About',
                            selected: selectedItem == 'about',
                            onTap: onAboutTap,
                          ),

                          SizedBox(height: isSmall ? 16 : 18),
                          Center(
                            child: Text(
                              'Version 1.0.0',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.drawerFooter.copyWith(
                                fontSize: isSmall ? 11 : 12,
                                color: AppColors.primaryDark.withOpacity(0.45),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double headerHeight, bool isSmall) {
    return SizedBox(
      height: headerHeight,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          isSmall ? 18 : 20,
          isSmall ? 24 : 30,
          isSmall ? 18 : 20,
          isSmall ? 20 : 24,
        ),
        child: Row(
          children: [
            Container(
              width: isSmall ? 58 : 66,
              height: isSmall ? 58 : 66,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(isSmall ? 14 : 16),
              ),
              child: Center(
                child: SafeLeafIcon(size: isSmall ? 38 : 44),
              ),
            ),
            SizedBox(width: isSmall ? 12 : 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SafeLeaf',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.drawerHeaderTitle.copyWith(
                      fontSize: isSmall ? 22 : 25,
                      fontWeight: FontWeight.w700,
                      height: 1.0,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: isSmall ? 4 : 6),
                  Text(
                    'Scan • Track • Stay Safe',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.drawerHeaderSubtitle.copyWith(
                      fontSize: isSmall ? 11 : 12,
                      color: Colors.white.withOpacity(0.82),
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isSmall) {
    return Text(
      title,
      style: AppTextStyles.drawerSectionTitle.copyWith(
        fontSize: isSmall ? 12 : 13,
        fontWeight: FontWeight.w800,
        color: AppColors.safe,
        letterSpacing: 0.7,
      ),
    );
  }

  Widget _buildBiometricItem(BuildContext context, bool isSmall) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 10 : 12,
        vertical: isSmall ? 8 : 10,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(isSmall ? 14 : 16),
      ),
      child: Row(
        children: [
          Container(
            width: isSmall ? 34 : 38,
            height: isSmall ? 34 : 38,
            decoration: BoxDecoration(
              color: AppColors.iconBackground,
              borderRadius: BorderRadius.circular(isSmall ? 10 : 12),
            ),
            child: Icon(
              Icons.fingerprint_rounded,
              color: AppColors.primary,
              size: isSmall ? 18 : 20,
            ),
          ),
          SizedBox(width: isSmall ? 10 : 12),
          Expanded(
            child: Text(
              'Biometric Lock',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.drawerItem.copyWith(
                fontSize: isSmall ? 14 : 15,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryDark,
              ),
            ),
          ),
          Transform.scale(
            scale: isSmall ? 0.78 : 0.86,
            child: Switch(
              value: biometricEnabled,
              onChanged: onBiometricChanged,
              activeColor: Colors.white,
              activeTrackColor: AppColors.safe,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: AppColors.primaryLight.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final size = MediaQuery.of(context).size;
    final bool isSmall = size.width < 360;
    final bool active = selected;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(isSmall ? 14 : 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(isSmall ? 14 : 16),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isSmall ? 10 : 12,
            vertical: isSmall ? 8 : 10,
          ),
          decoration: BoxDecoration(
            color: active ? AppColors.cardBackground : Colors.transparent,
            borderRadius: BorderRadius.circular(isSmall ? 14 : 16),
            border: Border.all(
              color: active
                  ? AppColors.primaryLight.withOpacity(0.28)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: isSmall ? 34 : 38,
                height: isSmall ? 34 : 38,
                decoration: BoxDecoration(
                  color: AppColors.iconBackground,
                  borderRadius: BorderRadius.circular(isSmall ? 10 : 12),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: isSmall ? 18 : 20,
                ),
              ),
              SizedBox(width: isSmall ? 10 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: (active
                              ? AppTextStyles.drawerItemActive
                              : AppTextStyles.drawerItem)
                          .copyWith(
                        fontSize: isSmall ? 14 : 15,
                        fontWeight: FontWeight.w500,
                        color:
                            active ? AppColors.primary : AppColors.primaryDark,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.drawerFooter.copyWith(
                          fontSize: isSmall ? 10 : 11,
                          color: AppColors.primaryDark.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: isSmall ? 4 : 6),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.primaryDark.withOpacity(0.72),
                size: isSmall ? 20 : 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}