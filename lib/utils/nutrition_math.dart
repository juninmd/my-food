/// Pure nutrition arithmetic shared by the orbit, plates and food form.
class NutritionMath {
  NutritionMath._();

  static const kcalPerGramProtein = 4;
  static const kcalPerGramCarbs = 4;
  static const kcalPerGramFat = 9;

  /// Energy implied by the macros (Atwater factors).
  static int kcalFromMacros(int protein, int carbs, int fat) =>
      protein * kcalPerGramProtein +
      carbs * kcalPerGramCarbs +
      fat * kcalPerGramFat;

  /// Share of calories coming from protein, carbs and fat, summing to 1.
  /// Returns equal thirds when every macro is zero.
  static List<double> calorieShares(int protein, int carbs, int fat) {
    final p = (protein * kcalPerGramProtein).toDouble();
    final c = (carbs * kcalPerGramCarbs).toDouble();
    final f = (fat * kcalPerGramFat).toDouble();
    final total = p + c + f;
    if (total <= 0) return const [1 / 3, 1 / 3, 1 / 3];
    return [p / total, c / total, f / total];
  }

  /// Progress toward [target], clamped to 0..1.
  static double progress(int value, int target) {
    if (target <= 0) return 0;
    return (value / target).clamp(0.0, 1.0);
  }
}
