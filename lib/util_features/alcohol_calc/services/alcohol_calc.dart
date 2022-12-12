class AlcoholCalc {
  static Map<String, double> alcoholFormulaUserData(
      {required String gender, required double weight}) {
    double divisionFactor, decay;
    switch (gender) {
      case "m":
        divisionFactor = 0.7;
        decay = 0.15;
        break;
      case "w":
        divisionFactor = 0.6;
        decay = 0.13;
        break;
      default:
        divisionFactor = 0.65;
        decay = 0.14;
        break;
    }
    double divisor = divisionFactor * weight;
    return {"decay_rate": decay, "alc_conversion": divisor};
  }

  static double alcoholGramsFromDrink(
      {required double litres, required double percentage}) {
    const double gramPerCm3 = 0.8;
    double cubicCm = litres * 1000;
    return cubicCm * (percentage / 100.0) * gramPerCm3;
  }
}
