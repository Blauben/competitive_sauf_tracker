import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sauf_tracker/main_features/pending_drinks/providers/pending_drinks_cubit.dart';
import 'package:sauf_tracker/main_features/pending_drinks/widgets/pending_drinks_card.dart';

class PendingDrinksBody extends StatelessWidget {
  const PendingDrinksBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pending drinks"),
      ),
      body: const _PendingDrinkListView(),
    );
  }
}

class _PendingDrinkListView extends StatelessWidget {
  const _PendingDrinkListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PendingDrinksCubit, PendingDrinksState>(
      bloc: PendingDrinksCubit()..fetchPending(),
      builder: (context, state) {
        if (state.pendingDrinks.isEmpty) {
          return const Center(
            child: Text("No pending drinks"),
          );
        }
        return ListView(
          children: [
            ExpansionTile(
              initiallyExpanded: true,
              title: Text(
                "Pending",
                style: TextStyle(fontSize: 20),
              ),
              leading: Icon(Icons.timelapse_rounded),
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: state.pendingDrinks.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 220,
                      margin: EdgeInsets.only(left: 15, right: 15),
                      child: PendingDrinkCard(
                          pendingDrink: state.pendingDrinks[index]),
                    );
                  },
                )
              ],
            ),
            ExpansionTile(
              initiallyExpanded: true,
              title: const Text(
                "Last 24h",
                style: TextStyle(fontSize: 20),
              ),
              leading: const Icon(Icons.more_time),
              children: [
                AnimatedList(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  initialItemCount: state.pendingDrinks.length,
                  itemBuilder: (context, index, an) {
                    return const Placeholder();
                  },
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
