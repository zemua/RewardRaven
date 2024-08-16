import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../entity/listed_app.dart';

class DatabaseHelper {
  // TODO change to firebase
  static final _databaseName = 'reward_raven_app.db';
  static final _databaseVersion = 1;

  final _logger = Logger();

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    if (_database == null) {
      throw Exception('Database is null');
    }
    return _database!;
  }

  _initDatabase() async {
    try {
      final path = await getDbPath();
      return await openDatabase(path,
          version: _databaseVersion, onCreate: _onCreate);
    } catch (e) {
      _logger.e("Error initializing database: $e");
    }
  }

  Future _onCreate(Database db, int version) async {
    try {
      await db.execute(ListedApp.createTableQuery);
    } catch (e) {
      _logger.e("Error creating table: $e");
    }
  }

  Future<String> getDbPath() async {
    return join(await getDatabasesPath(), _databaseName);
  }
}
