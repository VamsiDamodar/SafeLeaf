import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:safeleaf/modules/home/viewmodel/home_controller.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/utils/app_textstyles.dart';
import 'package:safeleaf/widgets/common/language_toggle.dart';
import 'package:safeleaf/widgets/splash/safeleaf_icon.dart';

class SafeLeafAppBar extends StatelessWidget implements PreferredSizeWidget {
  final IconData leadingIcon;
  final VoidCallback? onLeadingTap;

  const SafeLeafAppBar({
    super.key,
    this.leadingIcon = Icons.arrow_back_rounded,
    this.onLeadingTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final HomeController? homeController =
        Get.isRegistered<HomeController>() ? Get.find<HomeController>() : null;

    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      backgroundColor: AppColors.primary,
      elevation: 1,
      shadowColor: Colors.black26,
      toolbarHeight: preferredSize.height,
      leading: IconButton(
        icon: Icon(
          leadingIcon,
          color: Colors.white,
          size: 28,
        ),
        onPressed: onLeadingTap ?? () => Get.back(),
      ),
      titleSpacing: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SafeLeafIcon(size: 34),
          const SizedBox(width: 10),
          Text(
            'SafeLeaf',
            style: AppTextStyles.splashAppName.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Center(
            child: homeController == null
                ? const SizedBox(width: 78, height: 30)
                : Obx(
                    () => LanguageToggle(
                      isTelugu: homeController.isTelugu.value,
                      onToggle: homeController.toggleLanguage,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
