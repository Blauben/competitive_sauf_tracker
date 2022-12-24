import 'package:sauf_tracker/util_features/offlineDatabase/domain/models/pending_drink.dart';
import 'package:sqflite/sqflite.dart';

import '../models/drinks.dart';
import '../services/db_opt.dart';

class DBOptRepo {
  //TODO implement method to add end timestamp in consumed
  static Future<Database> _db = DBOptService.database();

  static Future<void> resetDatabase() async {
    DBOptService.resetDatabase("suff.db");
    _db = DBOptService.database();
  }

  static Future<List<Drink>> fetchDrinks() async {
    var maps = await DBOptService.retrieveFrom(await _db, "drinks");
    return Drink.fromJsonList(maps);
  }

  static void drinkConsumed(
      {required Drink drink, required DateTime begin, DateTime? end}) async {
    var drinkMap = drink.toMap();
    var tuple = {
      "drink_id": drinkMap["id"],
      "begin": begin.toString(),
      "end": end.toString()
    };
    DBOptService.insertInto(await _db, "consumed", [tuple]);
  }

  static void insertDrink(Drink drink) async {
    DBOptService.insertInto(await _db, "drinks", [drink.toMap()]);
  }

  static Future<int> getMaxDurationForDrink(Drink drink) async {
    var result = await DBOptService.retrieveFrom(await _db, "drink_category",
        condition: {"category_id": drink.categoryId});
    return int.parse(result.first["maxDuration"]);
  }

  static Future<void> updateDrinkQueue() async {
    String query =
        """WITH maxUnix AS (SELECT drink_id, maxEndUnixTime from activeDrinks)
UPDATE consumed AS c SET end = (SELECT datetime(maxEndUnixTime, 'unixepoch') FROM maxUnix m WHERE c.drink_id = m.drink_id AND m.maxEndUnixTime < CAST(strftime('%s','now') AS integer)) WHERE c.end IS NULL;""";
    DBOptService.query(db: await _db, query: query);
  }

  static Future<List<PendingDrink>> fetchDrinkQueue() async {
    var jsonList = await DBOptService.retrieveFrom(await _db, "activeDrinks");
    return PendingDrink.fromJsonList(jsonList);
  }
}
