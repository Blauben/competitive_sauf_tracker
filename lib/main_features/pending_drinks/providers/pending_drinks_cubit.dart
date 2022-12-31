import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sauf_tracker/util_features/persistence.dart';

import '../../../util_features/cache/repository/cache.dart';
import '../../../util_features/offlineDatabase/domain/models/drink.dart';
import '../../../util_features/offlineDatabase/domain/models/pending_drink.dart';

part 'pending_drinks_state.dart';

class PendingDrinksCubit extends Cubit<PendingDrinksState> {
  PendingDrinksCubit() : super(PendingDrinksInitial()) {
    Cache.pendingDrinksUpdateStream.listen((event) async {

      emit(PendingDrinksLoaded(pendingDrinks: event,drunk: [] ));
      PersistenceLayer.consumedLastTimeInterval(60*60*24).then((value) =>  emit(PendingDrinksLoaded(pendingDrinks: event,drunk: value )));
    });
  }

  void fetchPending() async {
    List<PendingDrink> pending = await PersistenceLayer.fetchPendingDrinks();

    emit(PendingDrinksLoaded(pendingDrinks: pending, drunk: []));
    PersistenceLayer.consumedLastTimeInterval(60*60*24).then((value) => emit(PendingDrinksLoaded(pendingDrinks: pending, drunk: value)));

  }
}
