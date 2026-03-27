import 'package:shared_preferences/shared_preferences.dart';

class DietConstants {
  static const int defaultCaloriesTarget = 2430; // 150*4 + 300*4 + 70*9 = 600 + 1200 + 630 = 2430
  static const int defaultProteinTarget = 150;
  static const int defaultCarbsTarget = 300;
  static const int defaultFatTarget = 70;
  static const int defaultWaterGlassTarget = 8;

  static Future<int> getCaloriesTarget() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('target_calories') ?? defaultCaloriesTarget;
  }

  static Future<int> getProteinTarget() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('target_protein') ?? defaultProteinTarget;
  }

  static Future<int> getCarbsTarget() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('target_carbs') ?? defaultCarbsTarget;
  }

  static Future<int> getFatTarget() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('target_fats') ?? defaultFatTarget;
  }
}
