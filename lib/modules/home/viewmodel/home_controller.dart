// lib/features/home/controller/home_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeleaf/data/models/home_category_model.dart';

class HomeController extends GetxController {
  final categories = <CategoryModel>[].obs;
  final searchQuery = ''.obs;
  final isTelugu = false.obs;

  // Drawer state
  final isDrawerOpen = false.obs;
  final isBiometricEnabled = false.obs;
  final selectedDrawerItem = 'home'.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeCategories();
    _loadDocumentCounts();
  }

  void _initializeCategories() {
    categories.value = [
      CategoryModel(
        id: 'aadhaar',
        name: 'Aadhaar',
        nameTelugu: 'ఆధార్',
        icon: Icons.credit_card,
        documentCount: 5,
        expiringCount: 0,
      ),
      CategoryModel(
        id: 'education',
        name: 'Education',
        nameTelugu: 'విద్య',
        icon: Icons.school,
        documentCount: 3,
        expiringCount: 1,
      ),
      CategoryModel(
        id: 'vehicle',
        name: 'Vehicle',
        nameTelugu: 'వాహనం',
        icon: Icons.directions_car,
        documentCount: 2,
        expiringCount: 1,
      ),
      CategoryModel(
        id: 'medical',
        name: 'Medical',
        nameTelugu: 'వైద్యం',
        icon: Icons.local_hospital,
        documentCount: 1,
        expiringCount: 0,
      ),
      CategoryModel(
        id: 'bank',
        name: 'Bank',
        nameTelugu: 'బ్యాంకు',
        icon: Icons.account_balance,
        documentCount: 7,
        expiringCount: 0,
      ),
      CategoryModel(
        id: 'other',
        name: 'Other',
        nameTelugu: 'ఇతర',
        icon: Icons.folder,
        documentCount: 0,
        expiringCount: 0,
      ),
    ];
  }

  Future<void> _loadDocumentCounts() async {
    // TODO: SQLite nundi load cheyyali later
  }

  List<CategoryModel> get filteredCategories {
    if (searchQuery.value.isEmpty) return categories;

    return categories.where((cat) {
      final name = isTelugu.value ? cat.nameTelugu : cat.name;
      return name.toLowerCase().contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  int get totalExpiringDocs {
    return categories.fold(0, (sum, cat) => sum + cat.expiringCount);
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
    await _loadDocumentCounts();
  }
}