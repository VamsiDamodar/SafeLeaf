import 'package:get/get.dart';
import 'package:safeleaf/modules/enhance_document_images/enhance_document_image_viewmodel.dart';

class EnhanceDocumentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EnhanceDocumentViewModel>(() => EnhanceDocumentViewModel());
  }
}