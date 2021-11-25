import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return await sql.openDatabase(path.join(dbPath, 'passvault.db'),
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE user_password_entries(id TEXT PRIMARY KEY, title TEXT, website TEXT, username TEXT, email TEXT, description TEXT, password TEXT)"
          );
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    await db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }
  
  static Future<void> delete(String table, String id) async {
    final db = await DBHelper.database();
    await db.delete(table, where: id);
  }
}
