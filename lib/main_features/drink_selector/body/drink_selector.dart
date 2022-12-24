import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sauf_tracker/main_features/drink_selector/providers/drink_list_cubit.dart';
import 'package:sauf_tracker/main_features/drink_selector/widgets/drink_selector_item.dart';
import 'package:sauf_tracker/util_features/offlineDatabase/domain/models/drink.dart';

class DrinkSelectorBody extends StatefulWidget {
  final DrinkCategory drinkCategory;

  const DrinkSelectorBody({Key? key, required this.drinkCategory})
      : super(key: key);

  @override
  State<DrinkSelectorBody> createState() => _DrinkSelectorBodyState();
}

class _DrinkSelectorBodyState extends State<DrinkSelectorBody> {
  @override
  Widget build(BuildContext context) {
    return _DrinkSelectorListView(
      drinkCategory: widget.drinkCategory,
      drinkListCubit: DrinkListCubit(),
    );
  }
}

class _DrinkSelectorListView extends StatelessWidget {
  final DrinkCategory drinkCategory;
  final DrinkListCubit drinkListCubit;

  const _DrinkSelectorListView(
      {Key? key, required this.drinkCategory, required this.drinkListCubit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrinkListCubit, DrinkListState>(
      bloc: drinkListCubit..loadDrinks(),
      builder: (context, state) {
        if (state.getDrinkByCategory(drinkCategory.index + 1).isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            itemCount: state.getDrinkByCategory(drinkCategory.index + 1).length,
            itemBuilder: (context, index) {
              return DrinkSelectorItem(
                  drink:
                      state.getDrinkByCategory(drinkCategory.index + 1)[index]);
            },
          );
        }
      },
    );
  }
}
