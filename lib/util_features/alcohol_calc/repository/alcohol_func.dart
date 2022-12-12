import 'package:sauf_tracker/util_features/alcohol_calc/services/alcohol_calc.dart';

class AlcoholFunc {
  static Map<String, double> alcoholFormulaUserData({
    required double weight,
    String gender = "d",
  }) {
    if (weight <= 30.0) {
      return {};
    }
    return AlcoholCalc.alcoholFormulaUserData(
        gender: gender.toLowerCase(), weight: weight);
  }

  static double alcoholGramsFromDrink(
      {required double litres, required double percentage}) {
    return AlcoholCalc.alcoholGramsFromDrink(
        litres: litres, percentage: percentage);
  }
}
