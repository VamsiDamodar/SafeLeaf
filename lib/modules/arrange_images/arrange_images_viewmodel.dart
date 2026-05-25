import 'dart:io';

import 'package:get/get.dart';
import 'package:safeleaf/routes/app_routes.dart';

class ArrangeImagesViewModel extends GetxController {
  final files = <File>[].obs;
  final fileNames = <String>[].obs;
  final fileSizes = <int>[].obs;
  final extensions = <String>[].obs;

  int get imageCount => files.length;

  @override
  void onInit() {
    super.onInit();

    // Preview screen nunchi vachina selected images data ikkada read chestham.
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

  // Drag and drop ayyaka image order update cheyyadaniki.
  void moveImage(int oldIndex, int newIndex) {
    if (oldIndex == newIndex) return;
    if (oldIndex < 0 || oldIndex >= files.length) return;
    if (newIndex < 0 || newIndex >= files.length) return;

    final movedFile = files.removeAt(oldIndex);
    final movedName = fileNames.removeAt(oldIndex);
    final movedSize = fileSizes.removeAt(oldIndex);
    final movedExtension = extensions.removeAt(oldIndex);

    files.insert(newIndex, movedFile);
    fileNames.insert(newIndex, movedName);
    fileSizes.insert(newIndex, movedSize);
    extensions.insert(newIndex, movedExtension);
  }

  String getFileName(int index) {
    if (index < fileNames.length) return fileNames[index];
    return 'Image ${index + 1}.jpg';
  }

  String getReadableSize(int index) {
    if (index >= fileSizes.length) return 'Unknown size';

    final size = fileSizes[index];
    if (size <= 0) return 'Unknown size';
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  void onAddMoreTap() {
    Get.snackbar(
      'Coming next',
      'Add more images flow will be added here.',
    );
  }

  void onNextTap() {
    Get.toNamed(
      Routes.DOCUMENT_DETAILS,
      arguments: {
        'files': files.toList(),
        'fileNames': fileNames.toList(),
        'fileSizes': fileSizes.toList(),
        'extensions': extensions.toList(),
      },
    );
  }
}