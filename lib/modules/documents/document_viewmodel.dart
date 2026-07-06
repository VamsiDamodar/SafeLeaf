import 'package:safeleaf/data/database/app_database.dart';
import 'package:safeleaf/data/models/home_category_model.dart';
import 'package:safeleaf/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:safeleaf/data/models/document_model.dart';

class DocumentController extends GetxController {
  final documents = <DocumentModel>[].obs;
  final filteredDocuments = <DocumentModel>[].obs;
  final isLoading = false.obs;
  final search = ''.obs;
  final _db = AppDatabase.instance;
  String? _loadedCategoryId;

  /// Loads documents by category and updates both [documents] and [filteredDocuments].
  Future<void> loadDocuments(String categoryId) async {
    if (_loadedCategoryId == categoryId && documents.isNotEmpty) {
      return;
    }

    isLoading.value = true;
    _loadedCategoryId = categoryId;

    try {
      final result = await _db.getDocumentsByCategory(categoryId);
      documents.assignAll(result);
      filteredDocuments.assignAll(result);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> reloadDocuments(CategoryModel category) async {
    _loadedCategoryId = null;
    await loadDocuments(category.id);
  }

  Future<void> openDocument(DocumentModel document) async {
    await Get.toNamed(
      Routes.DOCUMENT_DETAILS,
      arguments: {'document': document},
    );
  }

  /// Filters documents based on the search [query].
  void searchDocuments(String query) {
    search.value = query;

    if (query.isEmpty) {
      filteredDocuments.assignAll(documents);
      return;
    }

    final result = documents.where(
      (doc) => doc.title.toLowerCase().contains(query.toLowerCase()),
    ).toList();

    filteredDocuments.assignAll(result);
  }
}
