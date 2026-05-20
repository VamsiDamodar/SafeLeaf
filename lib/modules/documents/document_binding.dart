import 'package:get/get.dart';
import 'package:safeleaf/modules/documents/document_viewmodel.dart';


class DocumentBinding extends Bindings {

  @override
  void dependencies() {

    Get.lazyPut<DocumentController>(
      () => DocumentController(),
    );

  }
}