import 'package:sqflite/sqflite.dart';

class DBOpt {

  static String createStatement() {
    return """CREATE TABLE drinks (
                name varchar(30) primary key,
                percentage integer,
                volume integer
                );
                check(percentage > 0 and percentage <= 100);""";
  }

  static Future<void> insertInto(Future<Database> database, table , List<Map<String, dynamic>> rows) async {
    final db = await database;
    for (Map<String, dynamic> tuple in rows) {
      await db.insert(
          table,
          tuple,
          conflictAlgorithm: ConflictAlgorithm.rollback
      );
    }
  }

  static Future<List<Map<String, dynamic>>> retrieveFrom(Future<Database> database, String table) async {
      final db = await database;
      return await db.query(table);
  }

  static void deleteFrom(Future<Database> database, table, List<Map<String, dynamic>>? rows) async {
    final db = await database;
    if(rows == null) {
      db.delete(table);
      return;
    }
    for (Map<String, dynamic> tuple in rows) {
      String? where = _buildWhereCondition(tuple.keys);
      await db.delete(
          table,
          where: where,
          whereArgs: tuple.values.toList()
      );
    }
  }

  static String? _buildWhereCondition(Iterable<String> keys) {
    String where = "";
    for(String key in keys) {
      where += "$key = ? and ";
    }
    return where == ""?null: where.substring(0, where.length -5);
  }
}