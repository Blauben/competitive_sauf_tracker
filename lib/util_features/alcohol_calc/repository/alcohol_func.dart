import 'dart:async';

import 'package:sauf_tracker/util_features/alcohol_calc/services/alcohol_calc.dart';
import 'package:sauf_tracker/util_features/persistence.dart';

class AlcoholFunc {
  static Map<String, dynamic>? _alcCalcData;
  static double alcPromille = 0.0;
  static Timer? decayTimer;

  static Map<String, dynamic> alcoholFormulaUserData({
    required double weight,
    String gender = "d",
  }) {
    if (weight <= 30.0) {
      return {};
    }
    return AlcoholCalc.alcoholFormulaUserData(
        gender: gender.toLowerCase(), weight: weight);
  }

  static Future<Map<String, dynamic>> fetchUserAlcCalcData() async {
    return _alcCalcData ??=
        await PersistenceLayer.fetchUserAlcCalcDataFromDatabase();
  }

  static void invalidateStoredAlcCalcData() {
    _alcCalcData = null;
  }

  static double _alcoholGramsFromDrink(
      {required double litres, required double percentage}) {
    return AlcoholCalc.alcoholGramsFromDrink(
        litres: litres, percentage: percentage);
  }

  static Future<void> registerStartedDrink(
      {required int millilitres, required int percentage}) async {
    var grams = _alcoholGramsFromDrink(
        litres: millilitres / 1000.0, percentage: percentage / 100.0);
    var promille = grams / (await fetchUserAlcCalcData())["alc_conversion"] / 2;
    increasePromille(promille);
  }

  static Future<void> registerFinishedDrink(
      {required double millilitres, required double percentage}) async {
    var grams = _alcoholGramsFromDrink(
        litres: millilitres / 1000.0, percentage: percentage / 100.0);
    var promille = grams / (await fetchUserAlcCalcData())["alc_conversion"] / 2;
    increasePromille(promille);
  }

  static void increasePromille(double promille) {
    //TODO: implement controller update
    promille = promille.toStringAsFixed(1) as double;
    alcPromille += promille;
    configDecreaseTimer();
  }

  static Future<void> configDecreaseTimer() async {
    if (alcPromille > 0.0 && (decayTimer == null || !decayTimer!.isActive)) {
      double timeH = 0.1 / (await fetchUserAlcCalcData())["decay_rate"];
      int timeS = (3600 * timeH).ceil();
      decayTimer = Timer.periodic(Duration(seconds: timeS), fireDecreaseTimer);
    }
  }

  static Future<void> fireDecreaseTimer(Timer t) async {
    //TODO: implement controller update
    alcPromille -= 0.1;
    if (alcPromille == 0.0) {
      t.cancel();
    }
  }
}
