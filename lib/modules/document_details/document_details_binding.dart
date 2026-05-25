import 'package:get/get.dart';
import 'package:safeleaf/modules/document_details/document_details_viewmodel.dart';

class DocumentDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DocumentDetailsViewModel>(() => DocumentDetailsViewModel());
  }
}