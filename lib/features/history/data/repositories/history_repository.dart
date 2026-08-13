import 'package:key_handover_flutter/core/constants/key_status.dart';
import 'package:key_handover_flutter/core/database/database_helper.dart';
import 'package:key_handover_flutter/features/history/data/models/history_model.dart';

class HistoryRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<HistoryModel> create(HistoryModel record) async {
    final db = await _dbHelper.database;
    final id = await db.insert('history', record.toJson());
    return record.copyWith(id: id);
  }

  Future<HistoryModel> read(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'history',
      columns: null,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return HistoryModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<HistoryModel>> readAll() async {
    final db = await _dbHelper.database;
    const orderBy = 'id DESC';
    final result = await db.query('history', orderBy: orderBy);
    return result.map((json) => HistoryModel.fromJson(json)).toList();
  }

  Future<List<HistoryModel>> search(String query) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'history',
      where: 'keyName LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'id DESC',
    );
    return result.map((json) => HistoryModel.fromJson(json)).toList();
  }

  Future<HistoryModel?> findPendingRecord(String keyName) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'history',
      where: 'keyName = ? AND status = ?',
      whereArgs: [keyName, KeyStatus.taken.name],
      orderBy: 'id DESC',
      limit: 1,
    );
    if (result.isNotEmpty) {
      return HistoryModel.fromJson(result.first);
    }
    return null;
  }

  Future<int> update(HistoryModel record) async {
    final db = await _dbHelper.database;
    return db.update(
      'history',
      record.toJson(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('history', where: 'id = ?', whereArgs: [id]);
  }
}
