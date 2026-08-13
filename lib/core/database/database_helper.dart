import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('key_handover.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const textNullableType = 'TEXT';

    await db.execute('''
CREATE TABLE keys (
  id $idType,
  name $textType,
  keyId $textType,
  status $textType,
  holderName $textNullableType,
  holderDept $textNullableType,
  holderPhone $textNullableType,
  borrowedAt $textNullableType,
  expectedReturn $textNullableType
)
''');

    await db.execute('''
CREATE TABLE history (
  id $idType,
  keyName $textType,
  personName $textType,
  takenTime $textType,
  returnedTime $textType,
  status $textType
)
''');

    await _seedDatabase(db);
  }

  Future<void> _seedDatabase(Database db) async {
    final batch = db.batch();
    
    final keys = [
      {'name': 'Main Entrance Door', 'keyId': 'KEY-A01', 'status': 'available'},
      {'name': 'Server Room', 'keyId': 'KEY-S02', 'status': 'available'},
      {'name': 'Storage Room', 'keyId': 'KEY-ST01', 'status': 'available'},
      {'name': 'Back Gate', 'keyId': 'KEY-B04', 'status': 'available'},
      {'name': 'Manager Office', 'keyId': 'KEY-M05', 'status': 'available'},
    ];

    for (var key in keys) {
      batch.insert('keys', key);
    }
    
    await batch.commit();
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
