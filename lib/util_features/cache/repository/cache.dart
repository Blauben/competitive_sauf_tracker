import 'package:sauf_tracker/util_features/offlineDatabase/domain/repository/db_opt.dart';

import '../../offlineDatabase/domain/models/drinks.dart';

class Cache {
  static List<Drink>? _drinks;

  static Future<List<Drink>> fetchDrinks() async {
    if (_drinks != null) {
      return _drinks!;
    }
    return await _fetchFromDB();
  }

  static void reloadCache() {
    _fetchFromDB();
  }

  static Future<List<Drink>> _fetchFromDB() async {
    return _drinks = await DBOptRepo.fetchDrinks();
  }
}
