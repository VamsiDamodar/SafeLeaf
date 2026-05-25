import 'package:get/get.dart';
import 'package:safeleaf/modules/enhance_document/enhance_document_viewmodel.dart';

class EnhanceDocumentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EnhanceDocumentViewModel>(() => EnhanceDocumentViewModel());
  }
}