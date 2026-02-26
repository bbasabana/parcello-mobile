import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'parcello_offline.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE offline_parcels(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        data TEXT,
        status TEXT,
        createdAt TEXT
      )
    ''');
  }

  Future<int> insertParcel(Map<String, dynamic> parcelData) async {
    final db = await database;
    return await db.insert('offline_parcels', {
      'data': jsonEncode(parcelData),
      'status': 'pending',
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getPendingParcels() async {
    final db = await database;
    return await db.query('offline_parcels', where: 'status = ?', whereArgs: ['pending']);
  }

  Future<int> updateParcelStatus(int id, String status) async {
    final db = await database;
    return await db.update(
      'offline_parcels',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteParcel(int id) async {
    final db = await database;
    return await db.delete('offline_parcels', where: 'id = ?', whereArgs: [id]);
  }
}
