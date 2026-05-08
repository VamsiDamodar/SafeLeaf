import 'package:get/get.dart';
import 'package:safeleaf/modules/auth/viewmodel/biometric_setup_controller.dart';

class BiometricSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BiometricSetupController>(() => BiometricSetupController());
  }
}