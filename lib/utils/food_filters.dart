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

  static const _accented = 'áàâãäéèêëíìîïóòôõöúùûüçñ';
  static const _plain = 'aaaaaeeeeiiiiooooouuuucn';

  /// Lowercase without Portuguese diacritics, so "pao" finds "Pão".
  static String fold(String text) {
    final lower = text.toLowerCase();
    final out = StringBuffer();
    for (final ch in lower.split('')) {
      final i = _accented.indexOf(ch);
      out.write(i == -1 ? ch : _plain[i]);
    }
    return out.toString();
  }

  /// Foods that pass [filter] and contain [query] in name or description,
  /// ignoring case and accents.
  static List<FoodItem> apply(
      List<FoodItem> foods, FoodFilter filter, String query) {
    final q = fold(query.trim());
    return foods
        .where((f) => matches(f, filter))
        .where((f) =>
            q.isEmpty ||
            fold(f.name).contains(q) ||
            fold(f.description).contains(q))
        .toList();
  }
}
