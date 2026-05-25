import 'dart:io';

import 'package:get/get.dart';

class DocumentDetailsViewModel extends GetxController {
  final files = <File>[].obs;
  final fileNames = <String>[].obs;
  final fileSizes = <int>[].obs;
  final extensions = <String>[].obs;

  String get fileName => fileNames.isEmpty ? 'Selected document' : fileNames.first;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args is Map) {
      files.assignAll(List<File>.from(args['files'] ?? const <File>[]));
      fileNames.assignAll(List<String>.from(args['fileNames'] ?? const <String>[]));
      fileSizes.assignAll(List<int>.from(args['fileSizes'] ?? const <int>[]));
      extensions.assignAll(List<String>.from(args['extensions'] ?? const <String>[]));
    }
  }

  void onBackTap() {
    Get.back();
  }

  void onSaveTap() {
    Get.snackbar(
      'Coming next',
      'Save document logic will be added here.',
    );
  }
}