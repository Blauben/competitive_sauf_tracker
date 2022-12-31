import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sauf_tracker/util_features/offlineDatabase/domain/models/pending_drink.dart';
import 'package:sauf_tracker/util_features/persistence.dart';

class PendingDrinkCard extends StatefulWidget {
  final PendingDrink pendingDrink;

  const PendingDrinkCard({Key? key, required this.pendingDrink})
      : super(key: key);

  @override
  State<PendingDrinkCard> createState() => _PendingDrinkCardState();
}

class _PendingDrinkCardState extends State<PendingDrinkCard> {
  Duration timeSinceBegin = const Duration(seconds: 0);
  String timerText = "00:00:00";

  Timer? timer;

  @override
  void initState() {
    timeSinceBegin = DateTime.now().difference(widget.pendingDrink.begin);

    super.initState();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        timeSinceBegin = DateTime.now().difference(widget.pendingDrink.begin);
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        shadowColor: Colors.green,
        elevation: 3,
        child: InkWell(
          onTap: _onCardPress,
          child: Container(
            margin: const EdgeInsets.only(top: 30),
            child: Column(
              children: [
                widget.pendingDrink.drink.flutterIcon == null
                    ? Icon(
                        Icons.error_outline,
                        size: 60,
                      )
                    : Icon(
                        widget.pendingDrink.drink.flutterIcon!.icon,
                        size: 60,
                      ),
                const Spacer(),
                Text(
                  widget.pendingDrink.drink.name,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
                RichText(
                  text: TextSpan(
                      text: "Seit:",
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                      children: [
                        TextSpan(
                            text: "${_buildTimerText()}",
                            style: TextStyle(color: Colors.green))
                      ]),
                ),
                const Spacer(),
                OutlinedButton(
                  style: OutlinedButtonTheme.of(context).style,
                  onPressed: _onCheckPress,
                  child: const Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void _onCardPress() {}

  void _onCheckPress() {
    PersistenceLayer.finishConsumingDrink(pendingDrink: widget.pendingDrink);
  }

  String _buildTimerText() {
    NumberFormat formatter = NumberFormat("00");
    return "${formatter.format(timeSinceBegin.inHours % 24)}:${formatter.format(timeSinceBegin.inMinutes % 60)}:${formatter.format(timeSinceBegin.inSeconds % 60)}";
  }
}
