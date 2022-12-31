import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sauf_tracker/util_features/persistence.dart';

import '../../../util_features/cache/repository/cache.dart';
import '../../../util_features/offlineDatabase/domain/models/pending_drink.dart';

part 'pending_drinks_state.dart';

class PendingDrinksCubit extends Cubit<PendingDrinksState> {
  PendingDrinksCubit() : super(PendingDrinksInitial()) {
    Cache.pendingDrinksUpdateStream.listen((event) {
      emit(PendingDrinksLoaded(pendingDrinks: event));
    });
  }

  void fetchPending() async {
    print("Fetch");
    List<PendingDrink> pending = await PersistenceLayer.fetchPendingDrinks();
    emit(PendingDrinksLoaded(pendingDrinks: pending));
  }
}
