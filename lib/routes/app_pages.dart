import 'package:get/get.dart';
import 'package:safeleaf/modules/auth/binding/biometric_binding.dart';
import 'package:safeleaf/modules/auth/binding/pin_lock_binding.dart';
import 'package:safeleaf/modules/auth/binding/pin_setup_binding.dart';
import 'package:safeleaf/modules/auth/view/biometric_view.dart';
import 'package:safeleaf/modules/auth/view/pin_lock_view.dart';
import 'package:safeleaf/modules/auth/view/pin_setup_view.dart';
import 'package:safeleaf/modules/home/binding/home_binding.dart';
import 'package:safeleaf/modules/home/view/home_view.dart';
import 'package:safeleaf/modules/splash/view/splash_view.dart';
import 'package:safeleaf/modules/splash/binding/splash_binding.dart';
import 'package:safeleaf/routes/app_routes.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.PIN_SETUP,
      page: () => const PinSetupView(),
      binding: PinSetupBinding(),
    ),
    GetPage(
      name: Routes.BIOMETRIC_SETUP,
      page: () => const BiometricSetupView(),
      binding: BiometricSetupBinding(),
    ),
    GetPage(
      name: Routes.PIN_LOCK,
      page: () => const PinLockView(),
      binding: PinLockBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
  ];
}
