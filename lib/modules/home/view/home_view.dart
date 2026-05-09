// lib/features/home/view/home_view.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:safeleaf/modules/home/viewmodel/home_controller.dart';
import 'package:safeleaf/utils/app_colors.dart';
import 'package:safeleaf/utils/app_textstyles.dart';
import 'package:safeleaf/widgets/home/category_card.dart';
import 'package:safeleaf/widgets/home/home_drawer.dart';
import 'package:safeleaf/widgets/home/home_searchbar.dart';
import 'package:safeleaf/widgets/splash/safeleaf_icon.dart';
// import 'package:safeleaf/widgets/home/expiry_warning_section.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      onDrawerChanged: controller.setDrawerOpen,

      drawer: Obx(
        () => HomeDrawer(
          isTelugu: controller.isTelugu.value,
          biometricEnabled: controller.isBiometricEnabled.value,
          selectedItem: controller.selectedDrawerItem.value,
          onBiometricChanged: controller.toggleBiometric,
          onHomeTap: controller.onHomeTap,
          onMyDocumentsTap: controller.onMyDocumentsTap,
          onScanTap: controller.onScanDocumentTap,
          onLanguageTap: controller.onLanguageTap,
          onAboutTap: controller.onAboutTap,
        ),
      ),

      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColors.primary,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        backgroundColor: Colors.transparent,
        elevation: 1,
        shadowColor: Colors.black26,
        toolbarHeight: 72,
        leading: Builder(
          builder: (context) => Obx(
            () => AnimatedRotation(
              turns: controller.isDrawerOpen.value ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: IconButton(
                icon: const Icon(
                  Icons.menu_rounded,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  if (controller.isDrawerOpen.value) {
                    Get.back();
                  } else {
                    Scaffold.of(context).openDrawer();
                  }
                },
              ),
            ),
          ),
        ),
        titleSpacing: 0,
        flexibleSpace: Container(
        color: AppColors.primary,
        ),
        title: Row(
          children: [
            const SafeLeafIcon(size: 34),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'SafeLeaf',
                  style: AppTextStyles.splashAppName.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.0,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Scan • Track • Stay Safe',
                  style: AppTextStyles.splashTagline.copyWith(
                    fontSize: 8,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Obx(
            () => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: controller.toggleLanguage,
                icon: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Text(
                    controller.isTelugu.value ? 'EN' : 'తె',
                    style: AppTextStyles.splashTagline.copyWith(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: controller.refreshData,
        color: AppColors.accent,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: HomeSearchBar(
                onChanged: (value) {
                  controller.searchQuery.value = value;
                },
              ),
            ),
            Obx(() {
              if (controller.totalExpiringDocs > 0) {
                // return SliverToBoxAdapter(
                //   child: ExpiryWarningSection(count: controller.totalExpiringDocs),
                // );
              }
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            }),

            Obx(() {
              final cats = controller.filteredCategories;

              if (cats.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Image.asset(
                        'assets/notfound.png',
                        height: 180,
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(height: 20),

                      Text(
                        'No categories found',
                        style: AppTextStyles.splashTagline.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryDark.withOpacity(0.6),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ]
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return CategoryCard(
                        category: cats[index],
                        isTelugu: controller.isTelugu.value,
                        onTap: () => controller.openCategory(cats[index]),
                      );
                    },
                    childCount: cats.length,
                  ),
                ),
              );
            }),

            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.addDocument,
        backgroundColor: AppColors.accent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Add Document',
          style: AppTextStyles.splashTagline.copyWith(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }
}