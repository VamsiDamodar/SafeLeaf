import 'package:get/get.dart';
import 'package:safeleaf/data/models/document_model.dart';

class DocumentController extends GetxController {
  final documents = <DocumentModel>[].obs;
  final filteredDocuments = <DocumentModel>[].obs;
  final isLoading = false.obs;
  final search = ''.obs;
  final allDocuments = <DocumentModel>[
    const DocumentModel(
      id: 'dummy_aadhaar_back',
      title: 'Aadhaar Card Back',
      categoryId: 'aadhaar',
      filePath: null,
      documentNumber: 'XXXX-XXXX-1234',
      issueDate: '2025-05-12',
      expiryDate: null,
      notes: 'ID Proof',
      createdAt: '2025-05-12',
      updatedAt: '2025-05-12',
    ),
  ];

  /// Loads documents by category and updates both [documents] and [filteredDocuments].
  void loadDocuments(String categoryId) {
    isLoading.value = true;

    final result = allDocuments
        .where((doc) => doc.categoryId == categoryId)
        .toList();

    documents.assignAll(result);
    filteredDocuments.assignAll(result);

    isLoading.value = false;
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
