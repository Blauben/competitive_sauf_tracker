import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sauf_tracker/util_features/offlineDatabase/domain/models/drink.dart';
import 'package:sauf_tracker/util_features/persistence.dart';

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
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15),
      child: Card(
          shadowColor: Colors.teal,
          elevation: 3,
          child: InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (c) => _DrinkAddAlertDialog(drink: widget.drink ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  Icon(
                      widget.drink.flutterIcon == null
                          ? Icons.question_mark
                          : widget.drink.flutterIcon!.icon,
                      size: 90),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      Column(
                        children: [
                          Text(
                            widget.drink.name,
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${(widget.drink.volume / 1000).toStringAsPrecision(1)}L (${widget.drink.percentage}%)",
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.help),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}

class _DrinkAddAlertDialog extends StatefulWidget {
  final Drink drink;
  const _DrinkAddAlertDialog({Key? key, required this.drink}) : super(key: key);

  @override
  State<_DrinkAddAlertDialog> createState() => _DrinkAddAlertDialogState();
}

class _DrinkAddAlertDialogState extends State<_DrinkAddAlertDialog> {
  int timeLeft = 5;
  Timer? timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        timeLeft--;
        if(timeLeft == 0) {
          _close();
          timer.cancel();

        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Take a Photo ($timeLeft)"),
      content: Row(
        children: [
          Expanded(
            child: Card(
              child: IconButton(
                icon: const Icon(
                  Icons.cancel_outlined,
                  color: Colors.red,
                ),
                onPressed: _close,
              ),
            ),
          ),
          Expanded(
            child: Card(
              child: IconButton(
                icon: const Icon(
                  Icons.camera_alt,
                ),
                onPressed: _takePhoto,
              ),
            ),
          )
        ],
      ),
    );
  }


  void _takePhoto() {


  }


  void _close()  {
    print("ADD ");
    PersistenceLayer.startConsumingDrink(drink: widget.drink);
    Navigator.pop(context);
  }
}
