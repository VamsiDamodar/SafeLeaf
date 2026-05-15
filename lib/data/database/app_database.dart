import 'package:path/path.dart';
import 'package:safeleaf/data/models/document_model.dart';
import 'package:safeleaf/data/models/home_category_model.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }
  // -----------Database initiliazation ------------
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'safeleaf.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }
  // ----------------- Table Creation code On DB---------------
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        name_telugu TEXT NOT NULL,
        icon_code_point INTEGER NOT NULL,
        document_count INTEGER NOT NULL DEFAULT 0,
        expiring_count INTEGER NOT NULL DEFAULT 0,
        is_custom INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE documents (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        category_id TEXT NOT NULL,
        file_path TEXT,
        document_number TEXT,
        issue_date TEXT,
        expiry_date TEXT,
        notes TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
  }

  // ---------------- CATEGORY METHODS ----------------

  Future<List<CategoryModel>> getCategories() async {
    final db = await database;
    final maps = await db.query(
      'categories',
      orderBy: 'is_custom ASC, name ASC',
    );
    return maps.map(CategoryModel.fromMap).toList();
  }
  // ---------------- Adding the Record on DB ------------
  Future<void> insertCategory(CategoryModel category) async {
    final db = await database;
    await db.insert(
      'categories',
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  // ---------------- Adding the records on DB ------------
  Future<void> insertCategories(List<CategoryModel> categories) async {
    final db = await database;
    final batch = db.batch();

    for (final category in categories) {
      batch.insert(
        'categories',
        category.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }
  // ---------------- Update the records on DB ------------
  Future<void> updateCategory(CategoryModel category) async {
    final db = await database;
    await db.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }
  // ---------------- Delete the records on DB ------------
  Future<void> deleteCategory(String id) async {
    final db = await database;
    await db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  // ---------------- Getting the count of each category ------------
  Future<int> getCategoryCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM categories');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // ----------------Adding  Documents ----------------
  Future<void> insertDocument(DocumentModel document) async {
    final db = await database;
    await db.insert(
      'documents',
      document.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  // ----------------Update  Documents ----------------
  Future<void> updateDocument(DocumentModel document) async {
    final db = await database;
    await db.update(
      'documents',
      document.toMap(),
      where: 'id = ?',
      whereArgs: [document.id],
    );
  }
  // ---------------- Delete  Documents ----------------
  Future<void> deleteDocument(String id) async {
    final db = await database;
    await db.delete(
      'documents',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  // ----------------Fetching Documents by categoreis ----------------
  Future<List<DocumentModel>> getDocumentsByCategory(String categoryId) async {
    final db = await database;
    final maps = await db.query(
      'documents',
      where: 'category_id = ?',
      whereArgs: [categoryId],
      orderBy: 'created_at DESC',
    );
    return maps.map(DocumentModel.fromMap).toList();
  }
  // ----------------If the user want to delte the document safely moving the delete doc to other ----------------
  Future<void> moveDocumentsToOtherCategory(String oldCategoryId) async {
    final db = await database;
    await db.update(
      'documents',
      {'category_id': 'other'},
      where: 'category_id = ?',
      whereArgs: [oldCategoryId],
    );
  } 
  // ----------------Fetching Documents Count by categories ----------------
  Future<int> getDocumentCountByCategory(String categoryId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM documents WHERE category_id = ?',
      [categoryId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getExpiringCountByCategory(String categoryId) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT COUNT(*) as count
      FROM documents
      WHERE category_id = ?
      AND expiry_date IS NOT NULL
      AND date(expiry_date) >= date('now')
      AND date(expiry_date) <= date('now', '+30 day')
    ''', [categoryId]);

    return Sqflite.firstIntValue(result) ?? 0;
  }
}