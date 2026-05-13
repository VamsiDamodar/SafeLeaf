import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeleaf/data/database/app_database.dart';
import 'package:safeleaf/data/models/home_category_model.dart';
import 'package:safeleaf/widgets/home/delete_category_dialog.dart';
import 'package:safeleaf/widgets/home/rename_category_dialog.dart';

class HomeController extends GetxController {
  final categories = <CategoryModel>[].obs;
  final searchQuery = ''.obs;
  final isTelugu = false.obs;
  final isGridView = true.obs;

  final isDrawerOpen = false.obs;
  final isBiometricEnabled = false.obs;
  final selectedDrawerItem = 'home'.obs;

  final AppDatabase _db = AppDatabase.instance;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await _seedDefaultCategoriesIfNeeded();
    await _loadCategories();
    await _loadDocumentCounts();
  }

  Future<void> _seedDefaultCategoriesIfNeeded() async {
    final count = await _db.getCategoryCount();
    if (count > 0) return;

    final defaultCategories = [
      const CategoryModel(
        id: 'aadhaar',
        name: 'Aadhaar',
        nameTelugu: 'ఆధార్',
        icon: Icons.credit_card,
        documentCount: 0,
        expiringCount: 0,
        isCustom: false,
      ),
      const CategoryModel(
        id: 'education',
        name: 'Education',
        nameTelugu: 'విద్య',
        icon: Icons.school,
        documentCount: 0,
        expiringCount: 0,
        isCustom: false,
      ),
      const CategoryModel(
        id: 'vehicle',
        name: 'Vehicle',
        nameTelugu: 'వాహనం',
        icon: Icons.directions_car,
        documentCount: 0,
        expiringCount: 0,
        isCustom: false,
      ),
      const CategoryModel(
        id: 'medical',
        name: 'Medical',
        nameTelugu: 'వైద్యం',
        icon: Icons.local_hospital,
        documentCount: 0,
        expiringCount: 0,
        isCustom: false,
      ),
      const CategoryModel(
        id: 'bank',
        name: 'Bank',
        nameTelugu: 'బ్యాంకు',
        icon: Icons.account_balance,
        documentCount: 0,
        expiringCount: 0,
        isCustom: false,
      ),
      const CategoryModel(
        id: 'other',
        name: 'Other',
        nameTelugu: 'ఇతర',
        icon: Icons.folder,
        documentCount: 0,
        expiringCount: 0,
        isCustom: false,
      ),
    ];

    await _db.insertCategories(defaultCategories);
  }

  Future<void> _loadCategories() async {
    final data = await _db.getCategories();
    categories.assignAll(data);
  }

  Future<void> _loadDocumentCounts() async {
    final updatedCategories = <CategoryModel>[];

    for (final category in categories) {
      final docCount = await _db.getDocumentCountByCategory(category.id);
      final expiringCount = await _db.getExpiringCountByCategory(category.id);

      final updatedCategory = category.copyWith(
        documentCount: docCount,
        expiringCount: expiringCount,
      );

      await _db.updateCategory(updatedCategory);
      updatedCategories.add(updatedCategory);
    }

    categories.assignAll(updatedCategories);
  }

  List<CategoryModel> get filteredCategories {
    if (searchQuery.value.isEmpty) return categories;

    return categories.where((cat) {
      final nameToSearch = _getCategoryDisplayName(cat).toLowerCase();
      return nameToSearch.contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  int get totalExpiringDocs {
    return categories.fold(0, (sum, cat) => sum + cat.expiringCount);
  }

  String _getCategoryDisplayName(CategoryModel category) {
    if (isTelugu.value && category.nameTelugu.trim().isNotEmpty) {
      return category.nameTelugu;
    }
    return category.name;
  }

  void openCategory(CategoryModel category) {
    Get.toNamed('/documents', arguments: category);
  }

  void addDocument() {
    Get.toNamed('/add-document');
  }

  void toggleLanguage() {
    isTelugu.value = !isTelugu.value;
  }

  void toggleViewMode() {
    isGridView.value = !isGridView.value;
  }

  void setDrawerOpen(bool isOpen) {
    isDrawerOpen.value = isOpen;
  }

  void setDrawerItem(String item) {
    selectedDrawerItem.value = item;
  }

  void toggleBiometric(bool value) {
    isBiometricEnabled.value = value;
  }

  void onHomeTap() {
    selectedDrawerItem.value = 'home';
    Get.back();
  }

  void onMyDocumentsTap() {
    selectedDrawerItem.value = 'documents';
    Get.back();
    Get.toNamed('/documents');
  }

  void onScanDocumentTap() {
    selectedDrawerItem.value = 'scan';
    Get.back();
    Get.toNamed('/scan-document');
  }

  void onLanguageTap() {
    selectedDrawerItem.value = 'language';
    toggleLanguage();
    Get.back();
  }

  void onAboutTap() {
    selectedDrawerItem.value = 'about';
    Get.back();
    Get.defaultDialog(
      title: 'SafeLeaf',
      middleText: 'Scan • Track • Stay Safe\n\nVersion 1.0.0',
      textConfirm: 'OK',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFF2D6A4F),
      onConfirm: () => Get.back(),
    );
  }

  Future<void> refreshData() async {
    await _loadCategories();
    await _loadDocumentCounts();
  }

  void showAddCategoryDialog() {
    Get.dialog(
      CategoryNameDialog(
        title: isTelugu.value ? 'కేటగిరీ సృష్టించు' : 'Create Category',
        subtitle: isTelugu.value
            ? 'కొత్త కేటగిరీ పేరు ఇవ్వండి'
            : 'Enter name for the new category',
        actionText: isTelugu.value ? 'జోడించు' : 'Add',
        onSubmit: (name) async {
          final trimmedName = name.trim();

          if (trimmedName.isEmpty) {
            Get.snackbar(
              isTelugu.value ? 'లోపం' : 'Error',
              isTelugu.value
                  ? 'పేరు ఖాళీగా ఉండకూడదు'
                  : 'Name cannot be empty',
              snackPosition: SnackPosition.BOTTOM,
            );
            return;
          }

          final alreadyExists = categories.any(
            (c) => c.name.toLowerCase() == trimmedName.toLowerCase(),
          );

          if (alreadyExists) {
            Get.snackbar(
              isTelugu.value ? 'లోపం' : 'Error',
              isTelugu.value
                  ? 'ఈ కేటగిరీ ఇప్పటికే ఉంది'
                  : 'Category already exists',
              snackPosition: SnackPosition.BOTTOM,
            );
            return;
          }

          final category = CategoryModel(
            id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
            name: trimmedName,
            nameTelugu: trimmedName,
            icon: Icons.folder_open,
            documentCount: 0,
            expiringCount: 0,
            isCustom: true,
          );

          await _db.insertCategory(category);
          await _loadCategories();
          await _loadDocumentCounts();
          Get.back();
        },
      ),
      barrierDismissible: true,
    );
  }

  void renameCategory(CategoryModel category) {
    if (!category.isCustom) return;

    Get.dialog(
      CategoryNameDialog(
        title: isTelugu.value ? 'కేటగిరీ పేరు మార్చు' : 'Rename Category',
        subtitle: isTelugu.value
            ? 'ఈ కేటగిరీకి కొత్త పేరు ఇవ్వండి'
            : 'Enter new name for this category',
        actionText: isTelugu.value ? 'సేవ్' : 'Save',
        initialValue: category.name,
        onSubmit: (newName) async {
          final trimmedName = newName.trim();

          if (trimmedName.isEmpty) {
            Get.snackbar(
              isTelugu.value ? 'లోపం' : 'Error',
              isTelugu.value
                  ? 'పేరు ఖాళీగా ఉండకూడదు'
                  : 'Name cannot be empty',
              snackPosition: SnackPosition.BOTTOM,
            );
            return;
          }

          final duplicateExists = categories.any(
            (c) =>
                c.id != category.id &&
                c.name.toLowerCase() == trimmedName.toLowerCase(),
          );

          if (duplicateExists) {
            Get.snackbar(
              isTelugu.value ? 'లోపం' : 'Error',
              isTelugu.value
                  ? 'ఈ కేటగిరీ పేరు ఇప్పటికే ఉంది'
                  : 'Category name already exists',
              snackPosition: SnackPosition.BOTTOM,
            );
            return;
          }

          final updated = category.copyWith(
            name: trimmedName,
            nameTelugu: trimmedName,
          );

          await _db.updateCategory(updated);
          await _loadCategories();
          await _loadDocumentCounts();
          Get.back();
        },
      ),
      barrierDismissible: true,
    );
  }

  void deleteCategory(CategoryModel category) {
    if (!category.isCustom) return;

    final hasDocs = category.documentCount > 0;

    Get.dialog(
      DeleteCategoryDialog(
        isTelugu: isTelugu.value,
        categoryName: _getCategoryDisplayName(category),
        hasDocuments: hasDocs,
        documentCount: category.documentCount,
        onDelete: () async {
          await _moveDocumentsToOtherIfNeeded(category);
          await _db.deleteCategory(category.id);
          await _loadCategories();
          await _loadDocumentCounts();
          Get.back();

          Get.snackbar(
            isTelugu.value ? 'విజయం' : 'Success',
            isTelugu.value
                ? 'కేటగిరీ తొలగించబడింది'
                : 'Category deleted successfully',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
      ),
      barrierDismissible: true,
    );
  }

  Future<void> _moveDocumentsToOtherIfNeeded(CategoryModel category) async {
    if (category.documentCount == 0) return;
    await _db.moveDocumentsToOtherCategory(category.id);
  }
}