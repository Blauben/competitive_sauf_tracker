import 'dart:async';

import 'package:sauf_tracker/util_features/offlineDatabase/domain/models/pending_drink.dart';
import 'package:sqflite/sqflite.dart';

import '../models/drink.dart';
import '../services/db_opt.dart';

class DBOptRepo {
  static Future<Database> _db = DBOptService.database();

  static Future<void> resetDatabase() async {
    print("DB RESET");
    await DBOptService.resetDatabase("suff.db");
    _db = DBOptService.database();
  }

  static Future<List<Drink>> fetchDrinks() async {
    print("DB FETCH_DRINKS");
    var maps = await DBOptService.retrieveFrom(await _db, "drinks");
    return Drink.fromJsonList(maps);
  }

  static Future<void> addDrinkToConsumed(
      {required Drink drink, required DateTime begin, DateTime? end}) async {
    print("DB ADD_CONSUMED");
    await DBOptService.insertInto(await _db, "consumed", [
      {"drink_id": drink.id, "begin": begin.toString(), "end": end?.toString()}
    ]);
  }

  static Future<void> finishConsumingDrink({required Drink drink}) async {
    print("DB FINISH_CONSUMED");
    await DBOptService.updateIn(await _db, "consumed", {"drink_id": drink.id},
        {"end": DateTime.now().toString()});
  }

  static Future<void> insertDrink(Drink drink) async {
    print("DB INSERT_DRINK");
    await DBOptService.insertInto(await _db, "drinks", [drink.toMap()]);
  }

  static Future<void> _updateDrinkQueue() async {
    print("DB UPDATE_PENDING_BEFORE_FETCH");
    String query =
        """WITH maxUnix AS (SELECT drink_id, maxEndUnixTime from activeDrinks)
UPDATE consumed AS c SET end = (SELECT datetime(maxEndUnixTime, 'unixepoch') FROM maxUnix m WHERE c.drink_id = m.drink_id AND m.maxEndUnixTime < CAST(strftime('%s','now') AS integer)) WHERE c.end IS NULL;""";
    await DBOptService.query(db: await _db, query: query);
  }

  static Future<List<PendingDrink>> fetchPendingDrinks() async {
    print("DB FETCH_PENDING");
    await _updateDrinkQueue();
    var jsonList = await DBOptService.retrieveFrom(await _db, "activeDrinks");
    return await PendingDrink.fromJsonList(jsonList);
  }

  static Future<List<PendingDrink>> consumedLastTimeInterval(
      int seconds) async {
    print("DB FETCH_CONSUMED_INTERVAL");
    await _updateDrinkQueue();
    var jsonList =
        await DBOptService.retrieveFrom(await _db, "consumed", condition: {
      "CAST(strftime('%s','now') AS integer) - CAST(strftime('%s',begin) AS integer)":
          seconds
    }, conditionComp: [
      "<"
    ]);
    return await PendingDrink.fromJsonList(jsonList);
  }

  static Future<int> fetchNextPendingDrinkTimeDue() async {
    print("DB FETCH_UPDATE_TIME");
    var result = (await DBOptService.query(
        db: await _db,
        query:
            "SELECT COALESCE(MIN(maxEndUnixTime),0) as time FROM activeDrinks"));
    return result.first["time"];
  }
}
