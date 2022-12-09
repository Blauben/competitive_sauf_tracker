import 'package:flutter/material.dart';
import 'package:sauf_tracker/main_features/drink_selector/widgets/drink_selector_item.dart';

class DrinkSelectorBody extends StatelessWidget {
  const DrinkSelectorBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          height: 200,
          child: DrinkSelectorItem(title: "Bier", icon: Icon(Icons.sports_bar, size: 100),),

        ),
        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          height: 200,
          child: DrinkSelectorItem(title: "Wein", icon: Icon(Icons.wine_bar, size: 100,),),

        ),

        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          height: 200,
          child: DrinkSelectorItem(title: "Whisky", icon: Icon(Icons.liquor, size: 100,),),

        ),

        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          height: 200,
          child: DrinkSelectorItem(title: "Cocktail", icon: Icon(Icons.local_bar_sharp, size: 100,),),

        ),

      ],
    );
  }
}
