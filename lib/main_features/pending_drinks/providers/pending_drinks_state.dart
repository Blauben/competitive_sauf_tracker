part of 'pending_drinks_cubit.dart';

@immutable
abstract class PendingDrinksState {
  final List<PendingDrink> pendingDrinks;

  PendingDrinksState({required this.pendingDrinks});


}

class PendingDrinksInitial extends PendingDrinksState {
  PendingDrinksInitial() : super(pendingDrinks: []);

}


class PendingDrinksLoaded extends PendingDrinksState {
  PendingDrinksLoaded({required super.pendingDrinks});

}
