import 'dart:async';

import 'package:sauf_tracker/util_features/offlineDatabase/domain/repository/db_opt.dart';

import '../../offlineDatabase/domain/models/drink.dart';
import '../../offlineDatabase/domain/models/pending_drink.dart';

class Cache {
  static List<Drink>? _drinks;
  static List<PendingDrink>? _pending;

  static Timer? pendingTimer;

  static final StreamController<List<PendingDrink>>
      _pendingDrinksUpdateStreamController = StreamController.broadcast();

  static void initTimer() async {
    var unixDrinkTimelimitMilli =
        await DBOptRepo.fetchNextPendingDrinkTimeDue() * 1000;
    if (unixDrinkTimelimitMilli == 0 ||
        unixDrinkTimelimitMilli <= DateTime.now().millisecondsSinceEpoch) {
      pendingTimer?.cancel();
      return;
    }

    pendingTimer = Timer(
        Duration(
            milliseconds: (unixDrinkTimelimitMilli -
                DateTime.now().millisecondsSinceEpoch)),
        firePendingTimer);
  }

  static Future<void> firePendingTimer() async {
    print("TIMER_FIRED");
    pendingTimer?.cancel();
    await reloadCache(drinks: false, pending: true);
  }

  static Stream<List<PendingDrink>> get pendingDrinksUpdateStream {
    return _pendingDrinksUpdateStreamController.stream;
  }

  static Future<List<Drink>> fetchDrinks() async {
    if (_drinks == null) {
      await reloadCache(drinks: true, pending: false);
    }
    return _drinks!;
  }

  static Future<List<PendingDrink>> fetchPendingDrinks() async {
    if (_pending == null) {
      await reloadCache(drinks: false, pending: true);
    }
    return _pending!;
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
      _pendingDrinksUpdateStreamController.add(_pending ?? []);
      initTimer();
    }
  }
}
