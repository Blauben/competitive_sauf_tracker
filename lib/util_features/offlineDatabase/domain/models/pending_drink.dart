import '../../../cache/repository/cache.dart';
import 'drink.dart';

class PendingDrink {
  Drink drink;
  DateTime begin;
  DateTime? end;

  static Future<PendingDrink> create(
      {required int drinkId, required DateTime begin, DateTime? end}) async {
    var drink = await Cache.getDrinkById(drinkId);
    return PendingDrink._(drink, begin, end);
  }

  PendingDrink._(this.drink, this.begin, this.end);

  static Future<PendingDrink> fromJson(Map<String, dynamic> json) {
    DateTime? endStamp;
    if (json["end"] != null) {
      endStamp = DateTime.parse(json["end"]);
    }
    return create(
        drinkId: json["drink_id"],
        begin: DateTime.parse(json["begin"]),
        end: endStamp);
  }

  static Future<List<PendingDrink>> fromJsonList(
      List<Map<String, dynamic>> jsonList) async {
    List<PendingDrink> result = [];
    for (Map<String, dynamic> map in jsonList) {
      result.add(await PendingDrink.fromJson(map));
    }
    return result;
  }

  @override
  String toString() {
    String endStr = "";
    if (end != null) {
      endStr = ", end: $end";
    }
    return "PendingDrink{drink: ${drink.toString()}, begin: $begin$endStr}";
  }
}
