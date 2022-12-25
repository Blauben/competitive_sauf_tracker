import '../../../cache/repository/cache.dart';
import 'drink.dart';

class PendingDrink {
  Drink drink;
  DateTime begin;

  static Future<PendingDrink> create(
      {required int drinkId, required begin}) async {
    var drink = await Cache.getDrinkById(drinkId);
    return PendingDrink._(drink, begin);
  }

  PendingDrink._(this.drink, this.begin);

  static Future<PendingDrink> fromJson(Map<String, dynamic> json) {
    return create(
        drinkId: json["drink_id"], begin: DateTime.parse(json["begin"]));
  }

  static Future<List<PendingDrink>> fromJsonList(List<Map<String, dynamic>> jsonList) async {
    List<PendingDrink> result = [];
    for (Map<String, dynamic> map in jsonList) {
      result.add(await PendingDrink.fromJson(map));
    }
    return result;
  }

  @override
  String toString() {
    return "PendingDrink{drink: ${drink.toString()}, begin: $begin}";
  }
}
