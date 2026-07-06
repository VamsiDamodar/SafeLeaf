import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:safeleaf/data/database/app_database.dart';
import 'package:safeleaf/data/models/document_model.dart';
import 'package:safeleaf/routes/app_routes.dart';
import 'package:safeleaf/widgets/home/rename_category_dialog.dart';

class DocumentDetailsViewModel extends GetxController {
  final document = Rxn<DocumentModel>();
  final filePath = ''.obs;
  final fileName = ''.obs;
  final fileSize = 0.obs;
  final extension = ''.obs;
  final pageCount = RxnInt();
  final currentPdfPage = 0.obs;
  final isPdfLoading = false.obs;
  final pdfPages = <Uint8List>[].obs;
  final isFromDatabase = false.obs;
  final pdfPageController = PageController();

  File? get file {
    final path = filePath.value.trim();
    if (path.isEmpty) return null;
    return File(path);
  }

  bool get hasFile => file != null && file!.existsSync();

  bool get isImage =>
      ['jpg', 'jpeg', 'png', 'webp'].contains(extension.value.toLowerCase());

  bool get isPdf => extension.value.toLowerCase() == 'pdf';

  bool get canEdit =>
      ['jpg', 'jpeg', 'png', 'pdf'].contains(extension.value.toLowerCase());

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args is Map) {
      final doc = args['document'];
      if (doc is DocumentModel) {
        document.value = doc;
        isFromDatabase.value = true;
        filePath.value = doc.filePath ?? '';
        fileName.value = doc.title;
        extension.value = _guessExtension(filePath.value);
        fileSize.value = _readFileSize(filePath.value);
        if (isPdf && hasFile) {
          pageCount.value = _readPdfPageCount(file!);
        }
      } else {
        final files = List<File>.from(args['files'] ?? const <File>[]);
        final fileNames = List<String>.from(args['fileNames'] ?? const <String>[]);
        final fileSizes = List<int>.from(args['fileSizes'] ?? const <int>[]);
        final extensions = List<String>.from(args['extensions'] ?? const <String>[]);

        if (files.isNotEmpty) {
          filePath.value = files.first.path;
          fileName.value = fileNames.isNotEmpty
              ? fileNames.first
              : p.basenameWithoutExtension(files.first.path);
          fileSize.value =
              fileSizes.isNotEmpty ? fileSizes.first : _readFileSize(files.first.path);
          extension.value = extensions.isNotEmpty
              ? extensions.first.toLowerCase()
              : _guessExtension(files.first.path);
          if (isPdf) {
            pageCount.value = _readPdfPageCount(files.first);
          }
        }
      }
    }

    if (fileName.value.isEmpty && file != null) {
      fileName.value = p.basenameWithoutExtension(file!.path);
    }

    if (extension.value.isEmpty && file != null) {
      extension.value = _guessExtension(file!.path);
    }

    if (isPdf && hasFile) {
      _loadPdfPages();
    }
  }

  @override
  void onClose() {
    pdfPageController.dispose();
    super.onClose();
  }

  void onBackTap() {
    Get.back();
  }

  void onShareTap() {
    final currentFile = file;
    if (currentFile == null || !currentFile.existsSync()) {
      Get.snackbar('File missing', 'Saved file cannot be found.');
      return;
    }

    Share.shareXFiles(
      [XFile(currentFile.path)],
      text: fileName.value,
    );
  }

  Future<void> onEditTap() async {
    final currentFile = file;
    if (currentFile == null || !currentFile.existsSync()) {
      Get.snackbar('File missing', 'Saved file cannot be found.');
      return;
    }

    final ext = extension.value.toLowerCase();
    if (!['jpg', 'jpeg', 'png', 'pdf'].contains(ext)) {
      Get.snackbar(
        'Edit unavailable',
        'Editing is available for images and PDF files only.',
      );
      return;
    }

    await Get.toNamed(
      Routes.ENHANCE_DOCUMENT,
      arguments: {
        'files': [currentFile],
        'fileNames': [
          fileName.value.isEmpty ? p.basename(currentFile.path) : fileName.value,
        ],
        'fileSizes': [fileSize.value > 0 ? fileSize.value : currentFile.lengthSync()],
        'extensions': [ext],
      },
    );
  }

  Future<void> onRenameTap() async {
    if (!isFromDatabase.value || document.value == null) {
      Get.snackbar(
        'Rename unavailable',
        'Only saved documents can be renamed.',
      );
      return;
    }

    await Get.dialog(
      CategoryNameDialog(
        title: 'Rename Document',
        subtitle: 'Enter a new name for this saved document',
        actionText: 'Save',
        initialValue: fileName.value,
        onSubmit: (newName) async {
          final updatedName = newName.trim();
          if (updatedName.isEmpty) return;

          final current = document.value!;
          final updated = current.copyWith(
            title: updatedName,
            updatedAt: DateTime.now().toIso8601String(),
          );

          await AppDatabase.instance.updateDocument(updated);
          document.value = updated;
          fileName.value = updatedName;
          Get.back();
          Get.snackbar('Updated', 'Document renamed successfully.');
        },
      ),
      barrierDismissible: true,
    );
  }

  void onPdfPreviousTap() {
    if (currentPdfPage.value > 0) {
      final nextPage = currentPdfPage.value - 1;
      pdfPageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
      currentPdfPage.value = nextPage;
    }
  }

  void onPdfNextTap() {
    final count = pageCount.value ?? pdfPages.length;
    if (count > 0 && currentPdfPage.value < count - 1) {
      final nextPage = currentPdfPage.value + 1;
      pdfPageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
      currentPdfPage.value = nextPage;
    }
  }

  void onPdfPageChanged(int index) {
    currentPdfPage.value = index;
  }

  String getReadableSize() {
    final size = fileSize.value;
    if (size <= 0) return 'Unknown size';
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Future<void> _loadPdfPages() async {
    final currentFile = file;
    if (currentFile == null || !currentFile.existsSync()) return;

    isPdfLoading.value = true;
    try {
      final bytes = await currentFile.readAsBytes();
      final pageTotal = pageCount.value ?? _readPdfPageCount(currentFile) ?? 0;
      if (pageTotal <= 0) {
        pdfPages.clear();
        return;
      }

      pageCount.value = pageTotal;
      final rasterPages = await Printing.raster(
        bytes,
        pages: List<int>.generate(pageTotal, (index) => index),
        dpi: 140,
      ).toList();

      final renderedPages = await Future.wait(
        rasterPages.map((page) => page.toPng()),
      );
      pdfPages.assignAll(renderedPages);
      currentPdfPage.value = 0;
    } catch (_) {
      pdfPages.clear();
    } finally {
      isPdfLoading.value = false;
    }
  }

  String _guessExtension(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.jpeg')) return 'jpeg';
    if (lower.endsWith('.png')) return 'png';
    if (lower.endsWith('.pdf')) return 'pdf';
    if (lower.endsWith('.docx')) return 'docx';
    if (lower.endsWith('.doc')) return 'doc';
    if (lower.endsWith('.webp')) return 'webp';
    return 'jpg';
  }

  int _readFileSize(String path) {
    if (path.trim().isEmpty) return 0;
    final currentFile = File(path);
    if (!currentFile.existsSync()) return 0;
    return currentFile.lengthSync();
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
