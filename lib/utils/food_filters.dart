import 'package:webdiet/models/food_item.dart';

/// Quick filters of the food catalog.
enum FoodFilter { all, highProtein, lowCarb, light }

class FoodFilters {
  FoodFilters._();

  static const highProteinMin = 12;
  static const lowCarbMax = 10;
  static const lightKcalMax = 150;

  static bool matches(FoodItem food, FoodFilter filter) {
    switch (filter) {
      case FoodFilter.all:
        return true;
      case FoodFilter.highProtein:
        return food.protein >= highProteinMin;
      case FoodFilter.lowCarb:
        return food.carbs <= lowCarbMax;
      case FoodFilter.light:
        return food.calories <= lightKcalMax;
    }
  }

  /// Foods that pass [filter] and contain [query] in name or description.
  static List<FoodItem> apply(
      List<FoodItem> foods, FoodFilter filter, String query) {
    final q = query.trim().toLowerCase();
    return foods
        .where((f) => matches(f, filter))
        .where((f) =>
            q.isEmpty ||
            f.name.toLowerCase().contains(q) ||
            f.description.toLowerCase().contains(q))
        .toList();
  }
}
