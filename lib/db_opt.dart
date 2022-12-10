import 'package:sqflite/sqflite.dart';

class DBOpt {
  static void createDatabase(Database db) {
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
                check(percentage > 0 and percentage <= 100)
                );
                """,
      """CREATE TABLE users (
            user_id integer primary key,
            name varchar(30) not null,
            weight float,
            gender char,
            age integer,
            check(user_id >= 0 and age >= 16)
            );
            """,
      """CREATE VIEW scoreboard AS
            SELECT RANK() OVER(ORDER BY u.points desc), u.name, u.points
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
      Future<Database> database, String table) async {
    final db = await database;
    return await db.query(table);
  }

  static void deleteFrom(Future<Database> database, table,
      List<Map<String, dynamic>>? rows) async {
    final db = await database;
    if (rows == null) {
      db.delete(table);
      return;
    }
    for (Map<String, dynamic> tuple in rows) {
      String? where = _buildWhereCondition(tuple.keys);
      await db.delete(table, where: where, whereArgs: tuple.values.toList());
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
