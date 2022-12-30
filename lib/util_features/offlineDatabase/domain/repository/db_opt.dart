import 'dart:async';

import 'package:sauf_tracker/util_features/offlineDatabase/domain/models/pending_drink.dart';
import 'package:sqflite/sqflite.dart';

import '../models/drink.dart';
import '../services/db_opt.dart';

class DBOptRepo {
  static Future<Database> _db = DBOptService.database();

  static Future<void> resetDatabase() async {
    await DBOptService.resetDatabase("suff.db");
    _db = DBOptService.database();
  }

  static Future<List<Drink>> fetchDrinks() async {
    var maps = await DBOptService.retrieveFrom(await _db, "drinks");
    return Drink.fromJsonList(maps);
  }

  static Future<void> addDrinkToConsumed(
      {required Drink drink, required DateTime begin, DateTime? end}) async {
    await DBOptService.insertInto(await _db, "consumed", [
      {"drink_id": drink.id, "begin": begin.toString(), "end": end?.toString()}
    ]);
  }

  static Future<void> finishConsumingDrink({required Drink drink}) async {
    await DBOptService.updateIn(await _db, "consumed", {"drink_id": drink.id},
        {"end": DateTime.now().toString()});
  }

  static Future<void> insertDrink(Drink drink) async {
    await DBOptService.insertInto(await _db, "drinks", [drink.toMap()]);
  }

  static Future<void> _updateDrinkQueue() async {
    String query =
        """WITH maxUnix AS (SELECT drink_id, maxEndUnixTime from activeDrinks)
UPDATE consumed AS c SET end = (SELECT datetime(maxEndUnixTime, 'unixepoch') FROM maxUnix m WHERE c.drink_id = m.drink_id AND m.maxEndUnixTime < CAST(strftime('%s','now') AS integer)) WHERE c.end IS NULL;""";
    await DBOptService.query(db: await _db, query: query);
  }

  static Future<List<PendingDrink>> fetchPendingDrinks() async {
    await _updateDrinkQueue();
    var jsonList = await DBOptService.retrieveFrom(await _db, "activeDrinks");
    return await PendingDrink.fromJsonList(jsonList);
  }

  static Future<List<PendingDrink>> consumedLastTimeInterval(
      int seconds) async {
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
}
