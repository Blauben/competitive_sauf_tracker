import 'package:sauf_tracker/util_features/offlineDatabase/domain/repository/db_opt.dart';

import '../../offlineDatabase/domain/models/drinks.dart';

class Cache {
  static List<Drink>? _drinks;

  static List<Drink> fetchDrinks() {
    if (_drinks != null) {
      return _drinks!;
    }
    _fetchFromDB();
    return _drinks!;
  }

  static void reloadCache() {
    _fetchFromDB();
  }

  static void _fetchFromDB() async {
    _drinks = await DBOptRepo.fetchDrinks();
  }
}
