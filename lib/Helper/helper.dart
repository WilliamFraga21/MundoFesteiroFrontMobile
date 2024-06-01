import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../datas/user.dart';

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
      version: 3, // Incrementa a versão do banco de dados
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE tokens(id INTEGER PRIMARY KEY, token TEXT)",
        );
        await db.execute(
          "CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT, photoUrl TEXT)", // Adiciona a coluna 'photoUrl'
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          // Se a versão antiga for menor que 3, adicione a coluna 'photoUrl'
          await db.execute("ALTER TABLE users ADD COLUMN photoUrl TEXT");
        }
      },
    );
  }

  // Métodos para a tabela 'tokens'
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

  // Métodos para a tabela 'users'
  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('users');
  }

  Future<void> deleteUser() async {
    final db = await database;
    await db.delete('users');
  }
}
