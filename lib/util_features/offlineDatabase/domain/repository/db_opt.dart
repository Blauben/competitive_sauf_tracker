import 'package:sqflite/sqflite.dart';

import '../models/drinks.dart';
import '../services/db_opt.dart';

class DBOptRepo {
  static final Future<Database> _db = DBOptService.database();

  static Future<List<Drink>> fetchDrinks() async {
    var maps = await DBOptService.retrieveFrom(_db, "drinks");
    return Drink.fromJsonList(maps);
  }
}
