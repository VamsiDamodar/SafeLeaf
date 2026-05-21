import 'dart:io';

import 'package:get/get.dart';

class PreviewDocumentViewModel extends GetxController {
  final files = <File>[].obs;
  final fileNames = <String>[].obs;
  final fileSizes = <int>[].obs;
  final extensions = <String>[].obs;
  final pdfPageCount = RxnInt();

  bool get hasFiles => files.isNotEmpty;
  bool get isMultipleImages => files.length > 1 && isImageExtension(extension);
  String get fileName => fileNames.isEmpty ? 'Selected document' : fileNames.first;
  String get extension => extensions.isEmpty ? 'file' : extensions.first.toLowerCase();
  int get fileSize => fileSizes.fold(0, (total, size) => total + size);

  int? get pageCount {
    if (isImageExtension(extension)) return files.length;
    if (extension == 'pdf') return pdfPageCount.value;
    return null;
  }

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

    if (extension == 'pdf' && hasFiles) {
      pdfPageCount.value = _readPdfPageCount(files.first);
    }
  }

  bool isImageExtension(String value) {
    return ['jpg', 'jpeg', 'png'].contains(value.toLowerCase());
  }

  String getReadableSize() {
    final size = fileSize;
    if (size <= 0) return 'Unknown size';
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String getPageCountText() {
    final count = pageCount;
    if (count == null || count == 0) return 'Pages unavailable';
    return count == 1 ? '1 page' : '$count pages';
  }

  void onBackTap() {
    Get.back();
  }

  void onChangeFileTap() {
    Get.back();
  }

  void onNextTap() {
    Get.snackbar(
      'Next step',
      'Enhance document screen comes next.',
    );
  }

  int? _readPdfPageCount(File file) {
    try {
      final text = String.fromCharCodes(file.readAsBytesSync());
      final matches = RegExp(r'/Type\s*/Page\b').allMatches(text).length;
      return matches == 0 ? null : matches;
    } catch (_) {
      return null;
    }
  }
}
