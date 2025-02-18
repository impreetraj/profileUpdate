import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

  // Initialize Database
  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;
    
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
     final appDir = await getApplicationDocumentsDirectory();
    String path = join(appDir.path, 'user_profile.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE user (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            phone TEXT,
            email TEXT,
            address TEXT,
            profilePhoto TEXT
          )
        ''');
      },
    );
  }

  // Insert or Update User
  static Future<void> updateUser(Map<String, dynamic> user) async {
    final db = await getDatabase();
    await db.insert('user', user, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Fetch User Data
  static Future<Map<String, dynamic>?> getUser() async {
    final db = await getDatabase();
    List<Map<String, dynamic>> users = await db.query('user');
    
    if (users.isNotEmpty) {
      return users.first;
    }
    return null;
  }

}
