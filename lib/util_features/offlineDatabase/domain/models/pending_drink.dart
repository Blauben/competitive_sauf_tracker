import '../../../cache/repository/cache.dart';
import 'drink.dart';

class PendingDrink {
  Future<Drink>? drink;
  DateTime begin;

  PendingDrink({required int drinkId, required this.begin}) {
    drink = Cache.getDrinkById(drinkId);
  }

  factory PendingDrink.fromJson(Map<String, dynamic> json) {
    return PendingDrink(
        drinkId: json["drink_id"], begin: DateTime.parse(json["begin"]));
  }

  static List<PendingDrink> fromJsonList(List<Map<String, dynamic>> jsonList) {
    List<PendingDrink> result = [];
    for (Map<String, dynamic> map in jsonList) {
      result.add(PendingDrink.fromJson(map));
    }
    return result;
  }

  @override
  String toString() {
    return "PendingDrink{drink: ${drink.toString()}, begin: $begin}";
  }
}
