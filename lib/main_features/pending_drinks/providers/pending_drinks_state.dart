part of 'pending_drinks_cubit.dart';

@immutable
abstract class PendingDrinksState {
  final List<PendingDrink> pendingDrinks;
  final List<PendingDrink> drunk;
  PendingDrinksState({required this.pendingDrinks, required this.drunk});


}

class PendingDrinksInitial extends PendingDrinksState {
  PendingDrinksInitial() : super(pendingDrinks: [], drunk: []);

}


class PendingDrinksLoaded extends PendingDrinksState {
  PendingDrinksLoaded({required super.pendingDrinks, required super.drunk});

}
