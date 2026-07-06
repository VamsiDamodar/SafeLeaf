import 'package:get/get.dart';
import 'package:safeleaf/modules/saving/save_success_viewmodel.dart';

class SaveSuccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SaveSuccessViewModel>(() => SaveSuccessViewModel());
  }
}
