import 'package:flutter/material.dart';
import 'package:sauf_tracker/main_features/drink_selector/beer/body/beer_selector.dart';
import 'package:sauf_tracker/main_features/drink_selector/widgets/drink_selector_item.dart';
import 'package:sauf_tracker/main_features/scaffold/screens/main_scaffold.dart';
import 'package:sauf_tracker/util_features/custom_icons/domain/model/custom_icons.dart';

import '../../../main.dart';



class DrinkSelectorBody extends StatefulWidget {
  const DrinkSelectorBody({Key? key}) : super(key: key);

  @override
  State<DrinkSelectorBody> createState() => _DrinkSelectorBodyState();
}

class _DrinkSelectorBodyState extends State<DrinkSelectorBody> {
  int currentIndex  = 0;
  late List<Widget> drinkSelectorBodies;
  @override
  void initState() {
    drinkSelectorBodies = [_MainDrinkSelector(showBody: _showBody), const BeerSelectorBody(), Test(), Test(), Test(), Test(), Test(), Test()];
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: drinkSelectorBodies[currentIndex],
      onWillPop: () async{
        setState(() {
          currentIndex = 0;
        });
        return false;
      },
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
  const _MainDrinkSelector({Key? key, required this.showBody}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _buildCardItem(title: "Bier", icon: const Icon(Icons.sports_bar, size: 100,), index: 1),
        _buildCardItem(title: "Wein", icon: const Icon(Icons.wine_bar, size: 100,), index: 2),

        _buildCardItem(title: "Whisky", icon: const Icon(CustomIcons.whiskey, size: 90,), index: 3),

        _buildCardItem(title: "Shot", icon: const Icon(CustomIcons.tequila, size: 90,), index: 4),

        _buildCardItem(title: "Cocktail", icon: const Icon(CustomIcons.cocktail, size: 100,), index: 5)

      ],
    );
  }

  Container _buildCardItem({required String title, required Icon icon, required int index}) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15),
      height: 200,
      child: DrinkSelectorItem(title: title, icon: icon, onPressed: () => showBody(index),),


    );
  }
}


