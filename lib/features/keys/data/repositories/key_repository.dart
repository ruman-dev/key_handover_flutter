import 'package:key_handover_flutter/core/database/database_helper.dart';
import 'package:key_handover_flutter/features/keys/data/models/key_model.dart';

class KeyRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<KeyModel> read(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'keys',
      columns: null,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return KeyModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<KeyModel>> readAll() async {
    final db = await _dbHelper.database;
    final result = await db.query('keys');
    return result.map((json) => KeyModel.fromJson(json)).toList();
  }

  Future<List<KeyModel>> search(String query) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'keys',
      where: 'name LIKE ? OR keyId LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return result.map((json) => KeyModel.fromJson(json)).toList();
  }

  Future<int> update(KeyModel record) async {
    final db = await _dbHelper.database;
    return db.update(
      'keys',
      record.toJson(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }
}
