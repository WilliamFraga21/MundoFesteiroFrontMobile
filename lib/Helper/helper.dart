import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 2, // Incrementa a versão do banco de dados
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE tokens(id INTEGER PRIMARY KEY, token TEXT)",
        );
        await db.execute(
          "CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT, photo TEXT)",
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Se a versão antiga for menor que 2, recrie a tabela
          await db.execute("DROP TABLE IF EXISTS users");
          await db.execute(
            "CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT, photo TEXT)",
          );
        }
      },
    );
  }

  // Methods for 'tokens' table
  Future<void> insertToken(String token) async {
    final db = await database;
    await db.insert(
      'tokens',
      {'token': token},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getToken() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tokens');
    if (maps.isNotEmpty) {
      return maps.first['token'] as String?;
    }
    return null;
  }

  Future<void> deleteToken() async {
    final db = await database;
    await db.delete('tokens');
  }

  // Methods for 'users' table
  Future<void> insertUser(String name, String photo) async {
    final db = await database;
    await db.insert(
      'users',
      {'name': name, 'photo': photo}, // Incluir o valor da coluna 'photo'
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query(
      'users',
      columns: ['name', 'photo'], // Selecionar apenas os campos desejados
    );
  }

  Future<void> deleteUser() async {
    final db = await database;
    await db.delete('users');
  }
}
