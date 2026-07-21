import 'dart:async';

import 'dart:io';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:safeleaf/routes/app_routes.dart';
import 'package:share_plus/share_plus.dart';


class SaveSuccessViewModel extends GetxController {
  final progress = 0.0.obs;
  final isComplete = false.obs;
  final fileName = ''.obs;
  final filePath = ''.obs;
  final extension = ''.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      fileName.value = (args['fileName'] as String?) ?? '';
      filePath.value = (args['filePath'] as String?) ?? '';
      extension.value = (args['extension'] as String?) ?? '';
    }
    _startProgressAnimation();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future<void> onShareTap() async {
    final savedFile = _savedFile;
    if (savedFile == null) {
      Get.snackbar('File missing', 'Saved document cannot be found.');
      return;
    }

    await Share.shareXFiles([XFile(savedFile.path)], text: fileName.value);
  }

  void onViewDocumentTap() {
    final savedFile = _savedFile;
    if (savedFile == null) {
      Get.snackbar('File missing', 'Saved document cannot be found.');
      return;
    }

    Get.toNamed(
      Routes.DOCUMENT_DETAILS,
      arguments: {
        'files': [savedFile],
        'fileNames': [
          fileName.value.isEmpty
              ? p.basenameWithoutExtension(savedFile.path)
              : fileName.value,
        ],
        'extensions': [extension.value],
      },
    );
  }

  File? get _savedFile {
    final path = filePath.value.trim();
    if (path.isEmpty) return null;
    final file = File(path);
    return file.existsSync() ? file : null;
  }

  void _startProgressAnimation() {
    progress.value = 0.0;
    isComplete.value = false;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 70), (timer) {
      final next = (progress.value + 0.05).clamp(0.0, 1.0);
      progress.value = next;

      if (next >= 1.0) {
        isComplete.value = true;
        timer.cancel();
      }
    });
  }
}
