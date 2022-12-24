import 'package:sauf_tracker/util_features/offlineDatabase/domain/repository/db_opt.dart';

import '../../offlineDatabase/domain/models/drink.dart';
import '../../offlineDatabase/domain/models/pending_drink.dart';

class Cache {
  static List<Drink>? _drinks;

  static Future<List<Drink>> fetchDrinks() async {
    if (_drinks != null) {
      return _drinks!;
    }

    _drinks = await _fetchFromDB();

    return _drinks!;
  }

  static Drink getDrinkById(int id) {
    reloadCache();
    for (Drink drink in _drinks!) {
      if (drink.id == id) {
        return drink;
      }
    }
    throw Exception("No drink with id = $id found!");
  }

  static void reloadCache() {
    _fetchFromDB();
  }

  static Future<List<Drink>> _fetchFromDB() async {
    return _drinks = await DBOptRepo.fetchDrinks();
  }

  static Future<List<PendingDrink>> fetchDrinkQueue() async {
    DBOptRepo.updateDrinkQueue();
    return await DBOptRepo.fetchPendingDrinks();
  }
}
