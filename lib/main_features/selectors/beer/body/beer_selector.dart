import 'package:flutter/material.dart';

import '../../../drink_selector/widgets/drink_selector_item.dart';



class BeerSelectorBody extends StatelessWidget {
  const BeerSelectorBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [

        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          height: 200,
          child: DrinkCategorySelectorItem(title: "Klein (0,33L)", icon: Icon(Icons.sports_bar, size: 100), onPressed: () => {Navigator.pop(context)},),

        ),
        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          height: 200,
          child: DrinkCategorySelectorItem(title: "Halbe (0,5L)", icon: Icon(Icons.sports_bar, size: 100), onPressed: () => {},),

        ),

        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          height: 200,
          child: DrinkCategorySelectorItem(title: "Mass (1L)", icon: Icon(Icons.sports_bar, size: 100), onPressed: () => {},),

        ),
      ],
    );
  }
}
