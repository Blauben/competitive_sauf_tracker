import 'package:flutter/material.dart';

class DrinkSelector extends StatefulWidget {
  const DrinkSelector({super.key});

  @override
  createState() => DrinkSelectorState();
}

class DrinkSelectorState extends State<DrinkSelector> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Text("Drinks"));
  }
}
