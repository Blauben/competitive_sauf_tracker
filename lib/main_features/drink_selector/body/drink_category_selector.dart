import 'package:flutter/material.dart';
import 'package:sauf_tracker/main_features/drink_selector/body/drink_selector.dart';
import 'package:sauf_tracker/main_features/drink_selector/widgets/drink_selector_item.dart';
import 'package:sauf_tracker/util_features/custom_icons/domain/model/custom_icons.dart';
import 'package:sauf_tracker/util_features/offlineDatabase/domain/models/drinks.dart';

import '../../../main.dart';

class DrinkCategorySelectorBody extends StatefulWidget {
  const DrinkCategorySelectorBody({Key? key}) : super(key: key);

  @override
  State<DrinkCategorySelectorBody> createState() =>
      _DrinkCategorySelectorBodyState();
}

class _DrinkCategorySelectorBodyState extends State<DrinkCategorySelectorBody> {
  int currentIndex = 0;
  late List<Widget> drinkSelectorBodies;

  @override
  void initState() {
    drinkSelectorBodies = [
      _MainDrinkSelector(showBody: _showBody),
      const DrinkSelectorBody(drinkCategory: DrinkCategory.beer),
      const Test(),
      const Test(),
      const Test(),
      const Test(),
      const Test(),
      const Test()
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Competetive sauf tracker"),
        leading: currentIndex == 0
            ? null
            : IconButton(
                onPressed: () {
                  setState(() {
                    currentIndex = 0;
                  });
                },
                icon: const Icon(Icons.arrow_back)),
      ),
      body: WillPopScope(
        child: drinkSelectorBodies[currentIndex],
        onWillPop: () async {
          setState(() {
            currentIndex = 0;
          });
          return false;
        },
      ),
    );
  }

  void _showBody(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}

class _MainDrinkSelector extends StatelessWidget {
  final Function(int) showBody;

  const _MainDrinkSelector({Key? key, required this.showBody})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _buildCardItem(
            title: "Bier",
            icon: const Icon(
              Icons.sports_bar,
              size: 100,
            ),
            index: 1),
        _buildCardItem(
            title: "Wein",
            icon: const Icon(
              Icons.wine_bar,
              size: 100,
            ),
            index: 2),
        _buildCardItem(
            title: "Whisky",
            icon: const Icon(
              CustomIcons.whiskey,
              size: 90,
            ),
            index: 3),
        _buildCardItem(
            title: "Shot",
            icon: const Icon(
              CustomIcons.tequila,
              size: 90,
            ),
            index: 4),
        _buildCardItem(
            title: "Cocktail",
            icon: const Icon(
              CustomIcons.cocktail,
              size: 100,
            ),
            index: 5)
      ],
    );
  }

  Container _buildCardItem(
      {required String title, required Icon icon, required int index}) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15),
      height: 200,
      child: DrinkCategorySelectorItem(
        title: title,
        icon: icon,
        onPressed: () => showBody(index),
      ),
    );
  }
}
