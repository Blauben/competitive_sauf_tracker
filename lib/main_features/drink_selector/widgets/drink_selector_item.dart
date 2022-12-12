import 'package:flutter/material.dart';

class DrinkSelectorItem extends StatelessWidget {
  String title;
  Icon icon;
  void Function() onPressed;
  DrinkSelectorItem({Key? key, required this.title, required this.icon, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.teal,
      elevation: 3,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          margin: EdgeInsets.only(top: 30),
          child: Column(

            children: [
              icon,
              Text(title, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),)
            ],
          ),
        ),
      )
    );
  }
}



