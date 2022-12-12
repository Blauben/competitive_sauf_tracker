import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBOptService {
  static Future<Database> database() async {
    WidgetsFlutterBinding.ensureInitialized();
    return openDatabase(
      join(await getDatabasesPath(), "suff.db"),
      onCreate: (db, version) {
        DBOptService._createDatabase(db);
      },
      version: 1,
    );
  }

  static Future<void> resetDatabase(String dbName) async {
    WidgetsFlutterBinding.ensureInitialized();
    deleteDatabase(join(await getDatabasesPath(), dbName));
  }

  static void _createDatabase(Database db) {
    for (String query in _createStatement()) {
      db.execute(query);
    }
  }

  static List<String> _createStatement() {
    return [
      """CREATE TABLE drinks (
                name varchar(30) primary key,
                percentage integer,
                volume integer,
                icon varchar(30)
                check(percentage > 0 and percentage <= 100)
                );
                """,
      """CREATE TABLE users (
            user_id integer primary key,
            name varchar(30) not null,
            decay_rate float,
            alc_conversion float,            
            points integer,
            check(user_id >= 0)
            );
            """,
      """CREATE VIEW scoreboard AS
            SELECT RANK() OVER(ORDER BY u.points desc) as rank, u.name, u.points
            FROM users AS u;
            """
    ];
  }

  static Future<void> insertInto(
      Future<Database> database, table, List<Map<String, dynamic>> rows) async {
    final db = await database;
    for (Map<String, dynamic> tuple in rows) {
      await db.insert(table, tuple,
          conflictAlgorithm: ConflictAlgorithm.rollback);
    }
  }

  static Future<List<Map<String, dynamic>>> retrieveFrom(
      Future<Database> database, String table,
      {Map<String, dynamic>? condition}) async {
    final db = await database;
    if (condition == null) {
      return await db.query(table);
    }
    return await db.query(table,
        where: _buildWhereCondition(condition.keys),
        whereArgs: condition.values.toList());
  }

  static void deleteFrom(Future<Database> database, table,
      {List<Map<String, dynamic>>? rows}) async {
    final db = await database;
    if (rows == null) {
      db.delete(table);
      return;
    }
    for (Map<String, dynamic> tuple in rows) {
      await db.delete(table,
          where: _buildWhereCondition(tuple.keys),
          whereArgs: tuple.values.toList());
    }
  }

  static String? _buildWhereCondition(Iterable<String> keys) {
    String where = "";
    for (String key in keys) {
      where += "$key = ? and ";
    }
    return where == "" ? null : where.substring(0, where.length - 5);
  }
}
