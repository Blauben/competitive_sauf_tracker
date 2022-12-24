import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sauf_tracker/util_features/offlineDatabase/domain/models/drink.dart';

import '../../../util_features/persistence.dart';

part 'drink_list_state.dart';

class DrinkListCubit extends Cubit<DrinkListState> {
  DrinkListCubit() : super(DrinkListInitial());

  void loadDrinks() async {
    List<Drink> drinks = await PersistenceLayer.fetchDrinks();
    print(drinks);
    emit(DrinkListLoaded(drinks: drinks));
  }
}
