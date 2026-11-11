import 'package:webdiet/models/meal.dart';

/// The three moments of the day, with the planned time of each.
enum MealSlot {
  breakfast(8, 0),
  lunch(12, 0),
  dinner(19, 0);

  final int hour;
  final int minute;
  const MealSlot(this.hour, this.minute);

  String get time =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}

/// Meals chosen for today and the totals derived from them.
class DayPlan {
  final Map<MealSlot, Meal> meals;

  const DayPlan(this.meals);

  Meal operator [](MealSlot slot) => meals[slot]!;

  int _sum(int Function(Meal) f) =>
      meals.values.fold(0, (total, meal) => total + f(meal));

  int get calories => _sum((m) => m.calories);
  int get protein => _sum((m) => m.protein);
  int get carbs => _sum((m) => m.carbs);
  int get fat => _sum((m) => m.fat);

  /// Every ingredient of the day in slot order, repeated when two meals use it.
  List<String> get ingredients => [
        for (final slot in MealSlot.values) ...?meals[slot]?.ingredients,
      ];

  /// Ingredients without repetition.
  Set<String> get uniqueIngredients => ingredients.toSet();

  /// How many distinct ingredients are still missing from the cart.
  int remainingToBuy(Set<String> checked) =>
      uniqueIngredients.where((i) => !checked.contains(i)).length;
}
