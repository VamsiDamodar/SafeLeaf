import 'package:get/get.dart';
import 'package:safeleaf/modules/upload_document/upload_document_viewmodel.dart';

class UploadDocumentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UploadDocumentViewModel>(() => UploadDocumentViewModel());
  }
}