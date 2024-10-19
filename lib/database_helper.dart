import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  Database? _database;

  Future<void> _openDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'monitoreo_ruido.db');

    _database = await openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE ruido (id INTEGER PRIMARY KEY, date TEXT, decibeles REAL)',
        );
      },
      version: 1,
    );
  }

  Future<void> saveData(String date, double decibeles) async {
    await _openDatabase(); // Abre la base de datos
    await _database?.insert(
      'ruido',
      {'date': date, 'decibeles': decibeles},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getData() async {
    await _openDatabase(); // Abre la base de datos
    return await _database?.query('ruido') ?? [];
  }

  Future<void> closeDatabase() async {
    await _database?.close();
  }
}
