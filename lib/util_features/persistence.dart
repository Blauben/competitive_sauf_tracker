import 'package:sauf_tracker/util_features/offlineDatabase/domain/models/pending_drink.dart';

import 'cache/repository/cache.dart';
import 'offlineDatabase/domain/models/drink.dart';
import 'offlineDatabase/domain/repository/db_opt.dart';

class PersistenceLayer {
  //TODO: synchronize data

  static Future<void> resetDatabase() async {
    await DBOptRepo.resetDatabase();
    Cache.reloadCache(drinks: true, pending: true);
  }

  static Future<List<Drink>> fetchDrinks() {
    return Cache.fetchDrinks();
  }

  static Future<List<PendingDrink>> fetchPendingDrinks() {
    return Cache.fetchPendingDrinks();
  }

  static Future<void> startConsumingDrink({required Drink drink}) async {
    await DBOptRepo.addDrinkToConsumed(drink: drink, begin: DateTime.now());
    Cache.reloadCache(drinks: false, pending: true);
  }

  static Future<void> finishConsumingDrink({required Drink drink}) async {
    await DBOptRepo.finishConsumingDrink(drink: drink);
    Cache.reloadCache(drinks: false, pending: true);
  }

  static Future<void> insertDrink({required Drink drink}) async {
    await DBOptRepo.insertDrink(drink);
    Cache.reloadCache(drinks: true, pending: false);
  }
}
