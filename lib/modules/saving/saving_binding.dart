import 'package:get/get.dart';
import 'package:safeleaf/modules/saving/saving_viewmodel.dart';

class SavingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SavingViewModel>(() => SavingViewModel());
  }
}
