class DocumentModel {
  final String id;
  final String title;
  final String categoryId;
  final String? filePath;
  final String? documentNumber;
  final String? issueDate;
  final String? expiryDate;
  final String? notes;
  final String createdAt;
  final String updatedAt;

  const DocumentModel({
    required this.id,
    required this.title,
    required this.categoryId,
    this.filePath,
    this.documentNumber,
    this.issueDate,
    this.expiryDate,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  DocumentModel copyWith({
    String? id,
    String? title,
    String? categoryId,
    String? filePath,
    String? documentNumber,
    String? issueDate,
    String? expiryDate,
    String? notes,
    String? createdAt,
    String? updatedAt,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      title: title ?? this.title,
      categoryId: categoryId ?? this.categoryId,
      filePath: filePath ?? this.filePath,
      documentNumber: documentNumber ?? this.documentNumber,
      issueDate: issueDate ?? this.issueDate,
      expiryDate: expiryDate ?? this.expiryDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category_id': categoryId,
      'file_path': filePath,
      'document_number': documentNumber,
      'issue_date': issueDate,
      'expiry_date': expiryDate,
      'notes': notes,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      id: map['id'] as String,
      title: map['title'] as String,
      categoryId: map['category_id'] as String,
      filePath: map['file_path'] as String?,
      documentNumber: map['document_number'] as String?,
      issueDate: map['issue_date'] as String?,
      expiryDate: map['expiry_date'] as String?,
      notes: map['notes'] as String?,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
    );
  }
}