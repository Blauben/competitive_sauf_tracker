import 'package:sqflite/sqflite.dart';

import 'drinks.dart';

class DBOpt {

  static String createStatement() {
    return """CREATE TABLE drinks (
                name varchar(30) primary key,
                percentage integer,
                volume integer
                );
                check(percentage > 0 and percentage <= 100);
                INSERT INTO drinks(name, percentage, volume) VALUES ("Test", 50, 500);""";
  }

  static void insertInto(Future<Database> database, table , List<Map<String, dynamic>> rows) async {
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
}