import 'package:flutter/material.dart';

enum DrinkCategory {
  beer,wine
}


class Drink {
  int id;
  String name;
  int percentage;
  int volume;
  int category;
  String iconType;
  Icon? flutterIcon;
  Image? image;
  String? imagePath;

  static const defaultIcon = Icon(Icons.no_drinks);

  Drink(
      {required this.id,
      required this.name,
      required this.percentage,
      required this.volume,
      required this.category,
      this.iconType = "flutter",
      this.flutterIcon = defaultIcon,
      this.image});

  factory Drink.fromJson(Map<String, dynamic> json) {
    var drink = Drink(
      id: json["id"],
      name: json["name"],
      percentage: json["percentage"],
      volume: json["volume"],
      category: json["category"],
      iconType: json["iconType"],
    );

    switch (json["iconType"]) {
      case "flutter":
        drink.flutterIcon =
            Icon(IconData(int.parse(json["icon"]), fontFamily: 'MaterialIcons'));
        break;
      case "image":
        drink.image = Image.asset(json["icon"]);
        drink.imagePath = json["icon"];
        break;
    }
    return drink;
  }

  Map<String, dynamic> toMap() {
    var map = {
      "id": id,
      "name": name,
      "percentage": percentage,
      "volume": volume,
      "category": category,
      "iconType": iconType,
    };
    switch (iconType) {
      case "flutter":
        IconData? data = flutterIcon!.icon;
        map["icon"] =( data != null ? data.codePoint : 0xf04b6).toString();
        break;
      case "image":
        map["icon"] = imagePath!;
        break;
    }
    return map;
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
    return "Drink{id: $id, name: $name, percentage: $percentage, volume: $volume}";
  }
}
