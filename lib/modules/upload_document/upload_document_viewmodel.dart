import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:safeleaf/routes/app_routes.dart';

class UploadDocumentViewModel extends GetxController {
  // Multiple selected files ikkada store avuthayi
  final selectedFiles = <File>[].obs;

  // UI lo multiple file names chupinchadaniki
  final selectedFileNames = <String>[].obs;

  final selectedFileSizes = <int>[].obs;
  final selectedFileExtensions = <String>[].obs;

  void onBackTap() {
    Get.back();
  }

  Future<void> onChooseFileTap() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: [
          'jpg',
          'jpeg',
          'png',
          'pdf',
          'doc',
          'docx',
        ],
      );

      if (result == null || result.files.isEmpty) {
         Get.snackbar(
          'No file selected',
          'Please select images or one document.',
        );
        return;
      }

      final imageFiles = <PlatformFile>[];
      final documentFiles = <PlatformFile>[];

      for (final pickedFile in result.files) {
        final extension = pickedFile.name.split('.').last.toLowerCase();

        if (['jpg', 'jpeg', 'png'].contains(extension)) {
          imageFiles.add(pickedFile);
        } else if (['pdf', 'doc', 'docx'].contains(extension)) {
          documentFiles.add(pickedFile);
        }
      }
    
      // Images + PDF/DOC mix select chesthe block cheyyali
      if (imageFiles.isNotEmpty && documentFiles.isNotEmpty) {
        Get.snackbar(
          'Invalid selection',
          'Please select either multiple images or one document, not both.',
        );
        return;
      }

      // PDF/DOC multiple select chesthe block cheyyali
      if (documentFiles.length > 1) {
        Get.snackbar(
          'Invalid selection',
          'Please select only one PDF or document.',
        );
        return;
      }

      selectedFiles.clear();
      selectedFileNames.clear();
      selectedFileSizes.clear();
      selectedFileExtensions.clear();

      // Multiple images case
      if (imageFiles.isNotEmpty) {
        for (final image in imageFiles) {
          if (image.path == null) continue;

          selectedFiles.add(File(image.path!));
          selectedFileNames.add(image.name);
          selectedFileSizes.add(image.size);
          selectedFileExtensions.add(image.extension?.toLowerCase() ?? 'image');
        }

        _openPreview();

        return;
      }

      // Single PDF/DOC case
      if (documentFiles.length == 1) {
        final document = documentFiles.first;

        if (document.path == null) return;

        selectedFiles.add(File(document.path!));
        selectedFileNames.add(document.name);
        selectedFileSizes.add(document.size);
        selectedFileExtensions.add(document.extension?.toLowerCase() ?? 'file');

        _openPreview();

        return;
      }

      Get.snackbar(
        'Invalid file',
        'Please select JPG, PNG, PDF, DOC, or DOCX file',
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick files',
      );

      print('File Picker Error: $e');
    }
  }

  void onScanDocumentTap() {
    // TODO: scan document screen ki navigate cheyyali
  }

  void _openPreview() {
    Get.toNamed(
      Routes.PREVIEW_DOCUMENT,
      arguments: {
        'files': selectedFiles.toList(),
        'fileNames': selectedFileNames.toList(),
        'fileSizes': selectedFileSizes.toList(),
        'extensions': selectedFileExtensions.toList(),
      },
    );
  }
}
