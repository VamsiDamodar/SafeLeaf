import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

class UploadDocumentViewModel extends GetxController {
  // Multiple selected files ikkada store avuthayi
  final selectedFiles = <File>[].obs;

  // UI lo multiple file names chupinchadaniki
  final selectedFileNames = <String>[].obs;

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

      // Multiple images case
      if (imageFiles.isNotEmpty) {
        for (final image in imageFiles) {
          if (image.path == null) continue;

          selectedFiles.add(File(image.path!));
          selectedFileNames.add(image.name);
        }

        Get.snackbar(
          'Images selected',
          '${selectedFiles.length} images selected',
        );

        return;
      }

      // Single PDF/DOC case
      if (documentFiles.length == 1) {
        final document = documentFiles.first;

        if (document.path == null) return;

        selectedFiles.add(File(document.path!));
        selectedFileNames.add(document.name);

        Get.snackbar(
          'Document selected',
          document.name,
        );

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
}