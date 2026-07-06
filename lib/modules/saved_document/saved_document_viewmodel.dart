import 'dart:io';

import 'package:get/get.dart';
import 'package:safeleaf/routes/app_routes.dart';

class SavedDocumentViewModel extends GetxController {
  final filePath = ''.obs;
  final fileName = ''.obs;
  final categoryName = ''.obs;
  final fileSize = 0.obs;
  final extension = ''.obs;

  File? get file {
    final path = filePath.value.trim();
    if (path.isEmpty) return null;
    return File(path);
  }

  bool get hasFile => file != null && file!.existsSync();
  bool get isImage => ['jpg', 'jpeg', 'png', 'webp'].contains(extension.value.toLowerCase());

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args is Map) {
      filePath.value = (args['filePath'] as String?) ?? '';
      fileName.value = (args['fileName'] as String?) ?? '';
      categoryName.value = (args['categoryName'] as String?) ?? '';
      fileSize.value = (args['fileSize'] as int?) ?? 0;
      extension.value = ((args['extension'] as String?) ?? '').toLowerCase();
    }

    if (fileName.value.isEmpty && file != null) {
      fileName.value = file!.uri.pathSegments.isNotEmpty
          ? file!.uri.pathSegments.last
          : file!.path.split(Platform.pathSeparator).last;
    }

    if (extension.value.isEmpty && file != null) {
      final parts = file!.path.split('.');
      extension.value = parts.length > 1 ? parts.last.toLowerCase() : '';
    }
  }

  void onBackTap() {
    Get.back();
  }

  void onGoHomeTap() {
    Get.offAllNamed(Routes.HOME);
  }

  String getReadableSize() {
    final size = fileSize.value;
    if (size <= 0) return 'Unknown size';
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
