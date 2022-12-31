import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sauf_tracker/main_features/pending_drinks/providers/pending_drinks_cubit.dart';
import 'package:sauf_tracker/main_features/pending_drinks/widgets/pending_drinks_card.dart';
import 'package:sauf_tracker/util_features/cache/repository/cache.dart';
import 'package:sauf_tracker/util_features/persistence.dart';

class PendingDrinksBody extends StatelessWidget {
  const PendingDrinksBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pending drinks"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {  PersistenceLayer.resetDatabase();},
        child: const Icon(Icons.lock_reset,),

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
        return ListView(
          children: [
            ExpansionTile(
              initiallyExpanded: true,
              title: Text(
                "Pending (${state.pendingDrinks.length})",
                style: const TextStyle(fontSize: 20),
              ),
              leading: Icon(Icons.timelapse_rounded),
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.pendingDrinks.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 220,
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      child: PendingDrinkCard(
                          pendingDrink: state.pendingDrinks[index]),
                    );
                  },
                )
              ],
            ),
            Container(
              height: 30,
            ),
            ExpansionTile(
              initiallyExpanded: true,
              title: Text(
                "Last 24h (${state.drunk.length})",
                style: TextStyle(fontSize: 20),
              ),
              leading: const Icon(Icons.more_time),
              children: [
                AnimatedList(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  initialItemCount: state.drunk.length,
                  itemBuilder: (context, index, an) {
                    return Text(state.drunk[index].drink.name);
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
