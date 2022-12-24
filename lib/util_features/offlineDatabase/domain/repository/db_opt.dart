import 'package:sauf_tracker/util_features/offlineDatabase/domain/models/pending_drink.dart';
import 'package:sqflite/sqflite.dart';

import '../models/drink.dart';
import '../services/db_opt.dart';

class DBOptRepo {
  static Future<Database> _db = DBOptService.database();

  static Future<void> resetDatabase() async {
    DBOptService.resetDatabase("suff.db");
    _db = DBOptService.database();
  }

  static Future<List<Drink>> fetchDrinks() async {
    var maps = await DBOptService.retrieveFrom(await _db, "drinks");
    return Drink.fromJsonList(maps);
  }

  static void addDrinkToConsumed(
      {required Drink drink, required DateTime begin, DateTime? end}) async {
    var drinkMap = drink.toMap();
    var tuple = {
      "drink_id": drinkMap["id"],
      "begin": begin.toString(),
      "end": end.toString()
    };
    DBOptService.insertInto(await _db, "consumed", [tuple]);
  }

  static Future<void> finishConsumingDrink({required Drink drink}) async {
    DBOptService.updateIn(await _db, "consumed", {"drink_id": drink.id},
        {"begin": DateTime.now().toIso8601String()});
  }

  static void insertDrink(Drink drink) async {
    DBOptService.insertInto(await _db, "drinks", [drink.toMap()]);
  }

  static Future<void> updateDrinkQueue() async {
    String query =
        """WITH maxUnix AS (SELECT drink_id, maxEndUnixTime from activeDrinks)
UPDATE consumed AS c SET end = (SELECT datetime(maxEndUnixTime, 'unixepoch') FROM maxUnix m WHERE c.drink_id = m.drink_id AND m.maxEndUnixTime < CAST(strftime('%s','now') AS integer)) WHERE c.end IS NULL;""";
    DBOptService.query(db: await _db, query: query);
  }

  static Future<List<PendingDrink>> fetchPendingDrinks() async {
    var jsonList = await DBOptService.retrieveFrom(await _db, "activeDrinks");
    return await PendingDrink.fromJsonList(jsonList);
  }
}
