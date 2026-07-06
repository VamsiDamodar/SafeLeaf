import 'package:get/get.dart';
import 'package:safeleaf/modules/saved_document/saved_document_viewmodel.dart';

class SavedDocumentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SavedDocumentViewModel>(() => SavedDocumentViewModel());
  }
}
