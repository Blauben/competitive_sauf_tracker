import 'package:sqflite/sqflite.dart';

import '../models/drinks.dart';
import '../services/db_opt.dart';

class DBOptRepo {
  static final Future<Database> _db = DBOptService.database();

  static Future<List<Drink>> fetchDrinks() async {
    var maps = await DBOptService.retrieveFrom(_db, "drinks");
    return Drink.fromJsonList(maps);
  }

  static void drinkConsumed(
      {required Drink drink, required DateTime begin, required DateTime end}) {
    var drinkMap = drink.toMap();
    var tuple = {
      "drink_id": drinkMap["id"],
      "drink_name": drinkMap["name"],
      "begin": begin.toString(),
      "end": end.toString()
    };
    DBOptService.insertInto(_db, "consumed", [tuple]);
  }
}
