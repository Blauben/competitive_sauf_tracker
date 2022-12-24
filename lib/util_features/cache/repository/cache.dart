import 'package:flutter/material.dart';
import 'package:sauf_tracker/util_features/offlineDatabase/domain/repository/db_opt.dart';

import '../../offlineDatabase/domain/models/drinks.dart';

class Cache {
  static List<Drink>? _drinks;

  static Future<List<Drink>> fetchDrinks() async {
    if (_drinks != null) {
      return _drinks!;
    }
    DBOptRepo.insertDrink(Drink(id: 1, name: "Helles Mass", percentage: 5, volume: 1000, category: 1, flutterIcon: Icon(Icons.sports_bar)));
    DBOptRepo.insertDrink(Drink(id: 2, name: "Helles Halbe", percentage: 5, volume: 500, category: 1, flutterIcon: Icon(Icons.sports_bar)));
    DBOptRepo.insertDrink(Drink(id: 3, name: "Helles Klein", percentage: 5, volume: 333, category: 1, flutterIcon: Icon(Icons.sports_bar)));

    DBOptRepo.insertDrink(Drink(id: 4, name: "Rot Wein", percentage: 12, volume: 12, category: 2, flutterIcon: Icon(Icons.wine_bar)));


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
