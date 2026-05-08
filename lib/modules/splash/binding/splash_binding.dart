import 'package:get/get.dart';
import 'package:safeleaf/modules/splash/viewmodel/splash_viewmodel.dart';

/// Injects SplashController into the widget tree.
/// GetX destroys it automatically when the screen is removed.
class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}