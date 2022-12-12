

class Drink {
  String name;
  int percentage;
  int volume;
  int category;

  Drink(
      {required this.name,
      required this.percentage,
      required this.volume,
      required this.category});

  factory Drink.fromJson(Map<String, dynamic> json) {
    return Drink(
        name: json["name"],
        percentage: json["percentage"],
        volume: json["volume"],
        category: json["category"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "percentage": percentage,
      "volume": volume,
      "category": category,
    };
  }

  static List<Drink> fromJsonList(List<Map<String, dynamic>> jsonList) {
    List<Drink> result = [];
    for (Map<String, dynamic> map in jsonList) {
      result.add(Drink.fromJson(map));
    }
    return result;
  }

  @override
  String toString() {
    return "Drink{name: $name, percentage: $percentage, volume: $volume}";
  }
}
