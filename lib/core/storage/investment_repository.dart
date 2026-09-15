import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/investment.dart';

final investmentRepositoryProvider = Provider<InvestmentRepository>((ref) {
  return SqliteInvestmentRepository();
});

/// Offline-first local storage for investments (RDP section 26 - Offline &
/// Performance / section 21 - Architecture: Data layer). Wrapped behind a
/// repository interface so a future cloud-sync data source can be swapped
/// in without touching feature/UI code (RDP section 30).
abstract class InvestmentRepository {
  Future<List<Investment>> getAll();
  Future<Investment?> getById(String id);
  Future<void> save(Investment investment);
  Future<void> delete(String id);
}

class SqliteInvestmentRepository implements InvestmentRepository {
  static const _dbName = 'investments.db';
  static const _tableName = 'investments';
  
  Database? _db;

  Future<Database> get _database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id TEXT PRIMARY KEY,
            data TEXT
          )
        ''');
      },
    );
  }

  @override
  Future<List<Investment>> getAll() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    return maps.map((row) {
      final dataStr = row['data'] as String;
      return Investment.fromJson(Map<String, dynamic>.from(jsonDecode(dataStr)));
    }).toList();
  }

  @override
  Future<Investment?> getById(String id) async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    final dataStr = maps.first['data'] as String;
    return Investment.fromJson(Map<String, dynamic>.from(jsonDecode(dataStr)));
  }

  @override
  Future<void> save(Investment investment) async {
    final db = await _database;
    await db.insert(
      _tableName,
      {
        'id': investment.id,
        'data': jsonEncode(investment.toJson()),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> delete(String id) async {
    final db = await _database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
