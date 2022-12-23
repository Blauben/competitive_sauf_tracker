part of 'drink_list_cubit.dart';

@immutable
abstract class DrinkListState {
  List<Drink> getDrinks() {
    return [];
  }

  List<Drink> getDrinkByCategory(int cat) {
    return [];
  }
}

class DrinkListInitial extends DrinkListState {}

class DrinkListLoaded extends DrinkListState {
  List<Drink> drinks;

  DrinkListLoaded({required this.drinks});

  @override
  List<Drink> getDrinks() {
    return drinks;
  }

  @override
  List<Drink> getDrinkByCategory(int cat) {
    return drinks.where((element) => element.categoryId == cat).toList();
  }
}
