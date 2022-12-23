import 'package:flutter/material.dart';
import 'package:sauf_tracker/util_features/offlineDatabase/domain/models/drinks.dart';

class DrinkCategorySelectorItem extends StatelessWidget {
  String title;
  Icon icon;
  void Function() onPressed;

  DrinkCategorySelectorItem(
      {Key? key,
      required this.title,
      required this.icon,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        shadowColor: Colors.teal,
        elevation: 3,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            margin: const EdgeInsets.only(top: 30),
            child: Column(
              children: [
                icon,
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ));
  }
}

class DrinkSelectorItem extends StatefulWidget {
  final Drink drink;

  const DrinkSelectorItem({Key? key, required this.drink}) : super(key: key);

  @override
  State<DrinkSelectorItem> createState() => _DrinkSelectorItemState();
}

class _DrinkSelectorItemState extends State<DrinkSelectorItem> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.drink.name,
      style: const TextStyle(fontSize: 100),
    );
  }
}
