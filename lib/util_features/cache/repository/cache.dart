import 'package:sauf_tracker/util_features/offlineDatabase/domain/repository/db_opt.dart';

import '../../offlineDatabase/domain/models/drinks.dart';

class Cache {
  static List<Drink>? _drinks;

  static Future<List<Drink>> fetchDrinks() async {
    if (_drinks != null) {
      return _drinks!;
    }
    DBOptRepo.insertDrink(Drink(id: 1, name: "name", percentage: 12, volume: 12, category: 1));

    _drinks =  await _fetchFromDB();


    return _drinks!;
  }

  static void reloadCache() {
    _fetchFromDB();
  }

  static Future<List<Drink>> _fetchFromDB() async {
    return _drinks = await DBOptRepo.fetchDrinks();
  }
}
