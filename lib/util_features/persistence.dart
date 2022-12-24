import 'package:sauf_tracker/util_features/offlineDatabase/domain/models/pending_drink.dart';

import 'offlineDatabase/domain/models/drink.dart';
import 'offlineDatabase/domain/repository/db_opt.dart';

class PersistenceLayer {
  //TODO: synchronize data

  static void resetDatabase() {
    DBOptRepo.resetDatabase();
  }

  static Future<List<Drink>> fetchDrinks() {
    return DBOptRepo.fetchDrinks();
  }

  static Future<List<PendingDrink>> fetchPendingDrinks() {
    return DBOptRepo.fetchPendingDrinks();
  }

  static void startConsumingDrink({required Drink drink}) {
    DBOptRepo.addDrinkToConsumed(drink: drink, begin: DateTime.now());
  }

  static void finishConsumingDrink({required Drink drink}) {
    DBOptRepo.finishConsumingDrink(drink: drink);
  }

  static void insertDrink({required Drink drink}) {
    DBOptRepo.insertDrink(drink);
  }
}
