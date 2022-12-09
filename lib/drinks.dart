import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class drinksDB {

}

class Drink {
  String name;
  int percentage;
  int volume;

  Drink({required this.name, required this.percentage, required this.volume});

  Map<String, dynamic> toMap() {
    return {
      "name":name,
      "percentage": percentage,
      "volume": volume
    };
  }

  @override
  String toString() {
    return "Drink{name: $name, percentage: $percentage, volume: $volume}";
  }
}