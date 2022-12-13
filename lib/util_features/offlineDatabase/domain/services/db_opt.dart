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
    for (String query in _createStatement() + _insertStatement()) {
      db.execute(query);
    }
  }

  static List<String> _createStatement() {
    return [
      """CREATE TABLE drinks (
                id integer,
                name varchar(30) not null,
                percentage integer not null,
                volume integer not null,
                category integer references category,
                icon varchar(30) null,
                iconType varchar(7) null,
                primary key (id, name),
                check(percentage > 0 and percentage <= 100 and id >= 0),
                check(iconType IS null or iconType = 'image' or iconType = 'flutter')
                );
                """,
      """CREATE TABLE users (
            user_id integer primary key,
            name varchar(30) not null,
            decay_rate float noy null,
            alc_conversion float,            
            points integer,
            check(user_id >= 0)
            );
            """,
      """CREATE VIEW scoreboard AS
            SELECT RANK() OVER(ORDER BY u.points desc) as _rank, u.name, u.points
            FROM users AS u;
            """,
      """CREATE TABLE consumed (  
            drink_id integer references drinks on delete set null on update cascade,     
            drink_name varchar(30) references drinks on delete set null on update cascade,     
            begin timestamp,     
            end timestamp,    
            check(end > begin)
      )""",
      """CREATE TABLE drink_category (
        category_id integer primary key,
        name varchar(30)
      )"""
    ];
  }

  static List<String> _insertStatement() {
    return ["""INSERT INTO drink_category VALUES(1,'Bier'),(2,'Wein')"""];
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
