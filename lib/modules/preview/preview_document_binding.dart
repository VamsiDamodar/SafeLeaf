import 'package:get/get.dart';
import 'package:safeleaf/modules/preview/preview_document_viewmodel.dart';

class PreviewDocumentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PreviewDocumentViewModel>(() => PreviewDocumentViewModel());
  }
}
