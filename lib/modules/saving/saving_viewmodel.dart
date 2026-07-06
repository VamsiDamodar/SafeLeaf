import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:safeleaf/data/database/app_database.dart';
import 'package:safeleaf/data/models/document_model.dart';
import 'package:safeleaf/data/models/home_category_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:safeleaf/routes/app_routes.dart';

class SavingViewModel extends GetxController {
  final files = <File>[].obs;
  final fileNames = <String>[].obs;
  final fileSizes = <int>[].obs;
  final extensions = <String>[].obs;

  final categories = <CategoryModel>[].obs;
  final selectedCategory = Rxn<CategoryModel>();
  final categorySearchQuery = ''.obs;
  final isCategoryDropdownOpen = false.obs;
  final isLoadingCategories = true.obs;
  final isSaving = false.obs;

  final fileNameController = TextEditingController();
  final fileName = ''.obs;
  final selectedExtension = ''.obs;

  final extensionOptions = <String>[
    'JPG',
    'JPEG',
    'PNG',
    'PDF',
    'DOC',
    'DOCX',
  ].obs;

  List<CategoryModel> get filteredCategories {
    final query = categorySearchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return categories.toList();
    return categories.where((category) {
      return category.name.toLowerCase().contains(query) ||
          category.nameTelugu.toLowerCase().contains(query);
    }).toList();
  }

  String get readableSize {
    final total = fileSizes.fold<int>(0, (sum, size) => sum + size);
    if (total <= 0) return 'Unknown size';
    if (total < 1024) return '$total B';
    if (total < 1024 * 1024) return '${(total / 1024).toStringAsFixed(1)} KB';
    return '${(total / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String get primaryFileName {
    if (fileName.value.trim().isNotEmpty) return fileName.value.trim();
    if (fileNames.isNotEmpty) return fileNames.first;
    if (primaryFile != null) {
      return p.basenameWithoutExtension(primaryFile!.path);
    }
    return '';
  }

  String get primaryExtension {
    final value = selectedExtension.value.trim();
    if (value.isNotEmpty) return value;
    if (extensions.isNotEmpty) return extensions.first.toUpperCase();
    return 'JPG';
  }

  File? get primaryFile => files.isEmpty ? null : files.first;

  bool get canContinue =>
      primaryFileName.trim().isNotEmpty &&
      selectedCategory.value != null &&
      primaryExtension.trim().isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    debugPrint('[Saving] onInit called');

    final args = Get.arguments;
    if (args is Map) {
      debugPrint('[Saving] arguments received: ${args.keys.toList()}');
      files.assignAll(List<File>.from(args['files'] ?? const <File>[]));
      fileNames.assignAll(List<String>.from(args['fileNames'] ?? const <String>[]));
      fileSizes.assignAll(List<int>.from(args['fileSizes'] ?? const <int>[]));
      extensions.assignAll(List<String>.from(args['extensions'] ?? const <String>[]));

    }

    if (fileNames.isNotEmpty) {
      fileName.value = fileNames.first;
      fileNameController.text = fileNames.first;
    } else if (files.isNotEmpty) {
      final fallbackName = p.basenameWithoutExtension(files.first.path);
      fileName.value = fallbackName;
      fileNameController.text = fallbackName;
    }

    if (extensions.isNotEmpty) {
      selectedExtension.value = extensions.first.toUpperCase();
    } else if (files.isNotEmpty) {
      selectedExtension.value = _guessExtension(files.first.path);
    } else {
      selectedExtension.value = 'JPG';
    }

    debugPrint(
      '[Saving] initial fileName=$fileName, extension=$selectedExtension, files=${files.length}',
    );
    _loadUserCategories();

  }

  @override
  void onClose() {
    fileNameController.dispose();
    super.onClose();
  }

  void onBackTap() {
    Get.back();
  }

  void onFileNameChanged(String value) {
    fileName.value = value;
  }

  void onToggleCategoryDropdown() {
    isCategoryDropdownOpen.toggle();
    if (!isCategoryDropdownOpen.value) {
      categorySearchQuery.value = '';
    }
  }

  void onCategoryQueryChanged(String value) {
    categorySearchQuery.value = value;
  }

  void onCategorySelected(CategoryModel category) {
    debugPrint('[Saving] category selected: ${category.id} / ${category.name}');
    selectedCategory.value = category;
    isCategoryDropdownOpen.value = false;
    categorySearchQuery.value = '';
  }

  void onExtensionSelected(String value) {
    debugPrint('[Saving] extension selected: $value');
    selectedExtension.value = value;
  }

  Future<void> onContinueTap() async {
    debugPrint(
      '[Saving] Continue tapped -> canContinue=$canContinue, selectedCategory=${selectedCategory.value?.id}, fileName=$primaryFileName, extension=$primaryExtension, files=${files.length}',
    );
    if (!canContinue) {
      Get.snackbar(
        'Missing details',
        'Please select a category and file name before continuing.',
      );
      return;
    }

    final sourceFile = primaryFile;
    final category = selectedCategory.value;
    if (sourceFile == null || category == null) {
      Get.snackbar(
        'Missing details',
        'File or category is unavailable.',
      );
      return;
    }

    isSaving.value = true;
    try {
      debugPrint('[Saving] starting local save');
      final savedPath = await _saveFileToLocalStorage(
        sourceFile: sourceFile,
        categoryId: category.id,
        fileNameValue: primaryFileName,
        extensionValue: primaryExtension,
      );
      debugPrint('[Saving] file copied to: $savedPath');

      debugPrint('[Saving] inserting document record');
      await _saveDocumentRecord(
        categoryId: category.id,
        title: primaryFileName,
        filePath: savedPath,
      );

      debugPrint('[Saving] save API placeholder call');
      await _saveToApiPlaceholder(
        categoryId: category.id,
        title: primaryFileName,
        filePath: savedPath,
      );

      debugPrint('[Saving] save complete');
      Get.toNamed(
        Routes.SAVING_SUCCESS,
        arguments: {
          'fileName': primaryFileName,
        },
      );
    } catch (e) {
      debugPrint('[Saving] save failed: $e');
      Get.snackbar(
        'Save failed',
        'Unable to save document: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      debugPrint('[Saving] save flow ended');
      isSaving.value = false;
    }
  }

  Future<void> _loadUserCategories() async {
    isLoadingCategories.value = true;
    try {
      debugPrint('[Saving] loading categories from DB');
      final db = AppDatabase.instance;
      final data = await db.getCategories();
      debugPrint('[Saving] categories fetched count=${data.length}');

      if (data.isEmpty) {
        debugPrint('[Saving] DB empty, seeding default categories');
        await db.insertCategories(_defaultCategories);
        categories.assignAll(await db.getCategories());
      } else {
        categories.assignAll(data);
      }

      if (selectedCategory.value == null && categories.isNotEmpty) {
        debugPrint('[Saving] auto-select first category=${categories.first.id}');
        selectedCategory.value = categories.first;
      }
    } finally {
      isLoadingCategories.value = false;
      debugPrint('[Saving] category loading finished');
    }
  }

  Future<String> _saveFileToLocalStorage({
    required File sourceFile,
    required String categoryId,
    required String fileNameValue,
    required String extensionValue,
  }) async {
    debugPrint('[Saving] _saveFileToLocalStorage called');
    final directory = await getApplicationDocumentsDirectory();
    debugPrint('[Saving] app docs dir=${directory.path}');
    final safeName = _sanitizeFileName(fileNameValue);
    final normalizedExtension = extensionValue.replaceAll('.', '').toLowerCase();
    final targetDirectory = Directory(
      p.join(directory.path, 'documents', categoryId),
    );

    await targetDirectory.create(recursive: true);
    debugPrint('[Saving] target dir=${targetDirectory.path}');

    final targetPath = p.join(
      targetDirectory.path,
      '$safeName.${normalizedExtension.isEmpty ? 'jpg' : normalizedExtension}',
    );
    debugPrint('[Saving] target path=$targetPath');

    return sourceFile.copy(targetPath).then((file) => file.path);
  }

  Future<void> _saveDocumentRecord({
    required String categoryId,
    required String title,
    required String filePath,
  }) async {
    debugPrint('[Saving] _saveDocumentRecord called: categoryId=$categoryId title=$title filePath=$filePath');
    final now = DateTime.now().toIso8601String();
    final document = DocumentModel(
      id: 'doc_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      categoryId: categoryId,
      filePath: filePath,
      createdAt: now,
      updatedAt: now,
    );

    await AppDatabase.instance.insertDocument(document);
    debugPrint('[Saving] document inserted');
    final updatedCount = await AppDatabase.instance
        .getDocumentCountByCategory(categoryId);
    debugPrint('[Saving] updated count=$updatedCount');
    await AppDatabase.instance
        .updateCategoryDocumentCount(categoryId, updatedCount);
    debugPrint('[Saving] category count updated');
  }

  Future<void> _saveToApiPlaceholder({
    required String categoryId,
    required String title,
    required String filePath,
  }) async {
    // TODO: Connect backend API here.
    // Current implementation saves locally and into SQLite.
    debugPrint('[Saving] _saveToApiPlaceholder noop');
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }

  String _guessExtension(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.jpeg')) return 'JPEG';
    if (lower.endsWith('.png')) return 'PNG';
    if (lower.endsWith('.pdf')) return 'PDF';
    if (lower.endsWith('.docx')) return 'DOCX';
    if (lower.endsWith('.doc')) return 'DOC';
    return 'JPG';
  }

  String _sanitizeFileName(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 'document_${DateTime.now().millisecondsSinceEpoch}';
    }

    final buffer = StringBuffer();
    for (final unit in trimmed.runes) {
      final char = String.fromCharCode(unit);
      final allowed = RegExp(r'[a-zA-Z0-9 _.-]').hasMatch(char);
      buffer.write(allowed ? char : '_');
    }

    return buffer.toString().replaceAll(RegExp(r'\s+'), '_');
  }

  final List<CategoryModel> _defaultCategories = const [
    CategoryModel(
      id: 'farmer_documents',
      name: 'Farmer Documents',
      nameTelugu: 'Farmer Documents',
      icon: Icons.person,
      isCustom: true,
    ),
    CategoryModel(
      id: 'land_records',
      name: 'Land Records',
      nameTelugu: 'Land Records',
      icon: Icons.description_outlined,
      isCustom: true,
    ),
    CategoryModel(
      id: 'crop_related',
      name: 'Crop Related',
      nameTelugu: 'Crop Related',
      icon: Icons.eco_outlined,
      isCustom: true,
    ),
    CategoryModel(
      id: 'government_certificates',
      name: 'Government Certificates',
      nameTelugu: 'Government Certificates',
      icon: Icons.verified_outlined,
      isCustom: true,
    ),
    CategoryModel(
      id: 'insurance',
      name: 'Insurance',
      nameTelugu: 'Insurance',
      icon: Icons.shield_outlined,
      isCustom: true,
    ),
    CategoryModel(
      id: 'financial_documents',
      name: 'Financial Documents',
      nameTelugu: 'Financial Documents',
      icon: Icons.currency_rupee_rounded,
      isCustom: true,
    ),
    CategoryModel(
      id: 'others',
      name: 'Others',
      nameTelugu: 'Others',
      icon: Icons.more_horiz_rounded,
      isCustom: true,
    ),
  ];
}
