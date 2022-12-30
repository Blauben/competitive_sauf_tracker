import 'dart:async';

import 'package:sauf_tracker/util_features/offlineDatabase/domain/repository/db_opt.dart';

import '../../offlineDatabase/domain/models/drink.dart';
import '../../offlineDatabase/domain/models/pending_drink.dart';
import '../../persistence.dart';

class Cache {
  static List<Drink>? _drinks;
  static List<PendingDrink>? _pending;

  static Timer? pendingTimer;

  static void initTimer() async {
    var unixDrinkTimelimit = await DBOptRepo.fetchNextPendingDrinkTimeDue();
    if (unixDrinkTimelimit == 0) {
      pendingTimer = null;
      return;
    }
    pendingTimer = Timer(
        Duration(
            milliseconds:
                (unixDrinkTimelimit - DateTime.now().millisecondsSinceEpoch)),
        firePendingTimer);
  }

  static Future<void> firePendingTimer() async {
    await reloadCache(drinks: false, pending: true);
    PersistenceLayer.sendPendingDrinks(await fetchPendingDrinks());
    initTimer();
  }

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
    initTimer();
  }
}
