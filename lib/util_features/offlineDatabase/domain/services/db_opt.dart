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
                id integer primary key,
                name varchar(30) not null,
                percentage integer not null,
                volume integer not null,
                category_id integer references drink_category,
                icon varchar(30) null,
                iconType varchar(7) null,
                check(percentage > 0 and percentage <= 100 and id >= 0),
                check(iconType IS null or iconType = 'image' or iconType = 'flutter' or iconType = 'custom')
                );
                """,
      """CREATE TABLE users (
            user_id integer primary key,
            name varchar(30) not null,
            decay_rate float not null,
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
            begin timestamp not null,     
            end timestamp,    
            check(end >= begin)
      );
      """,
      """CREATE TABLE drink_category (
        category_id integer primary key,
        name varchar(30),
        maxDuration integer default 60
      );
      """,
      """CREATE VIEW activeDrinks AS
    SELECT 
        c.drink_id,
        c.begin,
        strftime('%s', c.begin) + dc.maxDuration * 60 AS maxEndUnixTime
    FROM
        consumed c,
        drinks d,
        drink_category dc
    WHERE
        c.drink_id = d.id
            AND d.category_id = dc.category_id
            AND c.end IS NULL;
    """
    ];
  }

  static List<String> _insertStatement() {
    return [
      """INSERT INTO drink_category VALUES(1,'Bier',30),(2,'Wein',60);""",
      """INSERT INTO drinks values(1,'Augustiner',5,500,1,NULL,NULL),(2,'Rose',12,300,2,NULL,NULL),(3,'Gluehwein',10,300,2,NULL,NULL);""",
      """INSERT INTO consumed values(1,'2022-12-23 03:00','2022-12-23 03:30'),(2,'2022-12-23 03:30',NULL),(3,datetime(strftime('%s','now') - 59*60 - 50, 'unixepoch'),NULL), (3,datetime(strftime('%s','now') - 59*60 - 40, 'unixepoch'),NULL),(2,datetime('now'),datetime('now'));"""
    ];
  }

  static Future<void> insertInto(
      Database db, table, List<Map<String, dynamic>> rows) async {
    for (Map<String, dynamic> tuple in rows) {
      await db.insert(table, tuple,
          conflictAlgorithm: ConflictAlgorithm.rollback);
    }
  }

  static Future<void> updateIn(Database db, String table,
      Map<String, dynamic> condition, Map<String, dynamic> updatedValues,
      {List<String>? conditionComp}) async {
    await db.update(table, updatedValues,
        where: _buildWhereCondition(condition.keys, compOp: conditionComp),
        whereArgs: condition.values.toList());
  }

  static Future<List<Map<String, dynamic>>> retrieveFrom(
      Database db, String table,
      {Map<String, dynamic>? condition, List<String>? conditionComp}) async {
    if (condition == null) {
      return await db.query(table);
    }
    return await db.query(table,
        where: _buildWhereCondition(condition.keys, compOp: conditionComp),
        whereArgs: condition.values.toList());
  }

  static Future<void> deleteFrom(Database db, table,
      {List<Map<String, dynamic>>? rows}) async {
    if (rows == null) {
      await db.delete(table);
      return;
    }
    for (Map<String, dynamic> tuple in rows) {
      await db.delete(table,
          where: _buildWhereCondition(tuple.keys),
          whereArgs: tuple.values.toList());
    }
  }

  static String? _buildWhereCondition(Iterable<String> keys,
      {List<String>? compOp}) {
    compOp ??= ["="];
    String where = "";
    for (int i = 0; i < keys.length; i++) {
      where += "${keys.elementAt(i)} ${compOp[i % compOp.length]} ? and ";
    }
    return where == "" ? null : where.substring(0, where.length - 5);
  }

  static Future<List<Map<String, dynamic>>> query(
      {required Database db,
      required String query,
      List<dynamic>? args}) async {
    return await db.rawQuery(query, args);
  }
}
