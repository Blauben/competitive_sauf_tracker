import 'package:sauf_tracker/util_features/offlineDatabase/domain/repository/db_opt.dart';

import '../../offlineDatabase/domain/models/drink.dart';
import '../../offlineDatabase/domain/models/pending_drink.dart';

class Cache {
  static List<Drink>? _drinks;
  static List<PendingDrink>? _pending;

  static Future<List<Drink>> fetchDrinks() async {
    return _drinks ??= await DBOptRepo.fetchDrinks();
  }

  static Future<List<PendingDrink>> fetchPendingDrinks() async {
    return _pending ??= await DBOptRepo.fetchPendingDrinks();
  }

  static Future<Drink> getDrinkById(int id) async {
    for (Drink drink in await fetchDrinks()) {
      if (drink.id == id) {
        return drink;
      }
    }
    throw Exception("No drink with id = $id found!");
  }

  static Future<void> reloadCache(
      {required bool drinks, required bool pending}) async {
    if (drinks) {
      _drinks = await DBOptRepo.fetchDrinks();
    }
    if (pending) {
      _pending = await DBOptRepo.fetchPendingDrinks();
    }
  }
}
