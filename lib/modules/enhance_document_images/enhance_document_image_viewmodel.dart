import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:safeleaf/routes/app_routes.dart';
import 'package:safeleaf/widgets/enhance_image_documets/enhance_crop_dialog.dart';

class EnhanceDocumentViewModel extends GetxController {
  final files = <File>[].obs;
  final fileNames = <String>[].obs;
  final fileSizes = <int>[].obs;
  final extensions = <String>[].obs;

  final currentIndex = 0.obs;
  final selectedFilterIndex = 0.obs;
  final applyFilterToAllPages = false.obs;
  final rotationTurns = <int>[].obs;
  final pageFilterIndexes = <int>[].obs;
  final pdfPageCount = RxnInt();

  int get imageCount => files.length;

  String get currentExtension {
    if (currentIndex.value >= extensions.length) return 'file';
    return extensions[currentIndex.value].toLowerCase();
  }

  int get currentRotationTurns {
    if (currentIndex.value >= rotationTurns.length) return 0;
    return rotationTurns[currentIndex.value];
  }

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args is Map) {
      files.assignAll(List<File>.from(args['files'] ?? const <File>[]));
      fileNames
          .assignAll(List<String>.from(args['fileNames'] ?? const <String>[]));
      fileSizes.assignAll(List<int>.from(args['fileSizes'] ?? const <int>[]));
      extensions
          .assignAll(List<String>.from(args['extensions'] ?? const <String>[]));
    }
    rotationTurns.assignAll(List<int>.filled(files.length, 0));
    pageFilterIndexes.assignAll(List<int>.filled(files.length, 0));

    if (currentExtension == 'pdf' && files.isNotEmpty) {
      pdfPageCount.value = _readPdfPageCount(files.first);
    }
  }

  void onBackTap() {
    Get.back();
  }

  void onPreviousTap() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
      selectedFilterIndex.value = pageFilterIndexes[currentIndex.value];
    }
  }

  void onNextImageTap() {
    if (currentIndex.value < files.length - 1) {
      currentIndex.value++;
      selectedFilterIndex.value = pageFilterIndexes[currentIndex.value];
    }
  }

  void onRotateTap() {
    if (files.isEmpty) return;

    // 0,1,2,3 turns means 0,90,180,270 degrees.
    // 4 ki reach ayyaka mallii 0 ki reset chestham.
    rotationTurns[currentIndex.value] =
        (rotationTurns[currentIndex.value] + 1) % 4;
    rotationTurns.refresh();
  }

  Future<void> onCropTap() async {
    if (files.isEmpty || currentExtension == 'pdf') return;

    final index = currentIndex.value;
    final croppedBytes = await Get.dialog<Uint8List>(
      EnhanceCropDialog(
        file: files[index],
        rotationTurns: currentRotationTurns,
      ),
      barrierDismissible: false,
    );

    if (croppedBytes == null || croppedBytes.isEmpty) return;

    final tempDir = await getTemporaryDirectory();
    final originalName = index < fileNames.length
        ? fileNames[index]
        : p.basename(files[index].path);
    final croppedName =
        '${p.basenameWithoutExtension(originalName)}_cropped_${DateTime.now().millisecondsSinceEpoch}.png';
    final croppedFile = File(p.join(tempDir.path, croppedName));
    await croppedFile.writeAsBytes(croppedBytes, flush: true);

    files[index] = croppedFile;
    if (index < fileNames.length) fileNames[index] = croppedName;
    if (index < fileSizes.length) fileSizes[index] = croppedBytes.length;
    if (index < extensions.length) extensions[index] = 'png';
    if (index < rotationTurns.length) rotationTurns[index] = 0;

    files.refresh();
    fileNames.refresh();
    fileSizes.refresh();
    extensions.refresh();
    rotationTurns.refresh();
  }

  void onDeleteTap() {
    if (files.isEmpty) return;

    files.removeAt(currentIndex.value);
    if (currentIndex.value < fileNames.length)
      fileNames.removeAt(currentIndex.value);
    if (currentIndex.value < fileSizes.length)
      fileSizes.removeAt(currentIndex.value);
    if (currentIndex.value < extensions.length)
      extensions.removeAt(currentIndex.value);
    if (currentIndex.value < rotationTurns.length)
      rotationTurns.removeAt(currentIndex.value);
    if (currentIndex.value < pageFilterIndexes.length) {
      pageFilterIndexes.removeAt(currentIndex.value);
    }
    if (currentExtension != 'pdf') pdfPageCount.value = null;

    if (currentIndex.value >= files.length && currentIndex.value > 0) {
      currentIndex.value--;
    }
  }

  void onFilterTap(int index) {
    selectedFilterIndex.value = index;

    // Toggle ON unte selected filter anni pages/images ki apply chestham.
    // Toggle OFF unte current page/image ki matrame apply chestham.
    if (applyFilterToAllPages.value) {
      for (var i = 0; i < pageFilterIndexes.length; i++) {
        pageFilterIndexes[i] = index;
      }
    } else if (currentIndex.value < pageFilterIndexes.length) {
      pageFilterIndexes[currentIndex.value] = index;
    }

    pageFilterIndexes.refresh();
  }

  void onApplyToAllPagesChanged(bool value) {
    applyFilterToAllPages.value = value;

    // Toggle ON chesthe current selected filter ni existing anni pages ki sync chestham.
    if (value) {
      for (var i = 0; i < pageFilterIndexes.length; i++) {
        pageFilterIndexes[i] = selectedFilterIndex.value;
      }
      pageFilterIndexes.refresh();
    }
  }

  void onContinueTap() {
    Get.toNamed(
      Routes.SAVING,
      arguments: {
        'files': files.toList(),
        'fileNames': fileNames.toList(),
        'fileSizes': fileSizes.toList(),
        'extensions': extensions.toList(),
      },
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
