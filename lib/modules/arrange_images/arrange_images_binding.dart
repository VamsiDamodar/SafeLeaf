import 'package:get/get.dart';
import 'package:safeleaf/modules/arrange_images/arrange_images_viewmodel.dart';

class ArrangeImagesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArrangeImagesViewModel>(() => ArrangeImagesViewModel());
  }
}