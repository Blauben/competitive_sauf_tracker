import 'package:flutter/material.dart';
import 'package:sauf_tracker/util_features/offlineDatabase/domain/models/pending_drink.dart';

class PendingDrinkCard extends StatefulWidget {
  final PendingDrink pendingDrink;
  const PendingDrinkCard({Key? key, required this.pendingDrink}) : super(key: key);

  @override
  State<PendingDrinkCard> createState() => _PendingDrinkCardState();
}

class _PendingDrinkCardState extends State<PendingDrinkCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Text(widget.pendingDrink.drink?.name ?? "Error 404 (1)"),
    );
  }
}
