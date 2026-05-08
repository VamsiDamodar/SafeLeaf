import 'package:get/get.dart';
import 'package:safeleaf/modules/auth/viewmodel/pin_lock_controller.dart';

class PinLockBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PinLockController>(() => PinLockController());
  }
}
