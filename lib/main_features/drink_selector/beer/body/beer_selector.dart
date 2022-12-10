import 'package:flutter/material.dart';

import '../../widgets/drink_selector_item.dart';

class BeerSelectorBody extends StatelessWidget {
  const BeerSelectorBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [

        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          height: 200,
          child: DrinkSelectorItem(title: "Klein (0,33L)", icon: Icon(Icons.sports_bar, size: 100),),

        ),
        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          height: 200,
          child: DrinkSelectorItem(title: "Halbe (0,5L)", icon: Icon(Icons.sports_bar, size: 100),),

        ),

        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          height: 200,
          child: DrinkSelectorItem(title: "Mass (1L)", icon: Icon(Icons.sports_bar, size: 100),),

        ),
      ],
    );
  }
}
