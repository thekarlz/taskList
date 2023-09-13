import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._internal();
  static Database? _database;

  factory DatabaseManager() {
    return _instance;
  }

  DatabaseManager._internal();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'tasks.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS tasks (
        id_task INTEGER PRIMARY KEY AUTOINCREMENT,
        fk_group INT,
        tk_description TEXT,
        tk_enddate DATETIME,
        tk_priority Text,
        tk_status INT
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS groups (
        id_group INTEGER PRIMARY KEY AUTOINCREMENT,
        gp_description TEXT,
        gp_status INT
      )
    ''');
  }
}
