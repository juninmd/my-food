import 'package:flutter_test/flutter_test.dart';
import 'package:webdiet/models/day_plan.dart';
import 'package:webdiet/models/food_item.dart';
import 'package:webdiet/models/meal.dart';
import 'package:webdiet/utils/day_clock.dart';
import 'package:webdiet/utils/food_filters.dart';
import 'package:webdiet/utils/nutrition_math.dart';

Meal meal(String name, int kcal, int p, int c, int f, List<String> ing) => Meal(
    name: name,
    imagePath: '',
    calories: kcal,
    protein: p,
    carbs: c,
    fat: f,
    description: '',
    ingredients: ing);

void main() {
  group('NutritionMath', () {
    test('kcal from macros uses 4/4/9', () {
      expect(NutritionMath.kcalFromMacros(10, 20, 5), 10 * 4 + 20 * 4 + 5 * 9);
    });

    test('calorie shares sum to one and fall back to thirds', () {
      final s = NutritionMath.calorieShares(25, 25, 0);
      expect(s[0], closeTo(0.5, 1e-9));
      expect(s[2], 0);
      expect(s.reduce((a, b) => a + b), closeTo(1, 1e-9));
      expect(NutritionMath.calorieShares(0, 0, 0), [1 / 3, 1 / 3, 1 / 3]);
    });

    test('progress clamps to 0..1', () {
      expect(NutritionMath.progress(50, 100), 0.5);
      expect(NutritionMath.progress(300, 100), 1);
      expect(NutritionMath.progress(10, 0), 0);
    });
  });

  group('DayPlan', () {
    final plan = DayPlan({
      MealSlot.breakfast: meal('A', 300, 15, 30, 12, ['Eggs', 'Salt']),
      MealSlot.lunch: meal('B', 500, 40, 60, 10, ['Chicken', 'Salt']),
      MealSlot.dinner: meal('C', 250, 5, 40, 8, ['Carrot']),
    });

    test('totals add every meal', () {
      expect(plan.calories, 1050);
      expect(plan.protein, 60);
      expect(plan.carbs, 130);
      expect(plan.fat, 30);
    });

    test('ingredients keep repeats; remaining ignores checked', () {
      expect(plan.ingredients, ['Eggs', 'Salt', 'Chicken', 'Salt', 'Carrot']);
      expect(plan.uniqueIngredients.length, 4);
      expect(plan.remainingToBuy({'Salt', 'Unknown'}), 3);
    });
  });

  group('DayClock', () {
    DateTime at(int h, int m) => DateTime(2026, 1, 1, h, m);

    test('first meal is next early in the morning', () {
      final s = DayClock.statuses(at(6, 0));
      expect(s[MealSlot.breakfast], SlotStatus.next);
      expect(s[MealSlot.lunch], SlotStatus.later);
      expect(s[MealSlot.dinner], SlotStatus.later);
    });

    test('meal is done one hour after its time', () {
      expect(DayClock.statuses(at(8, 59))[MealSlot.breakfast], SlotStatus.next);
      final s = DayClock.statuses(at(9, 0));
      expect(s[MealSlot.breakfast], SlotStatus.done);
      expect(s[MealSlot.lunch], SlotStatus.next);
    });

    test('late night marks everything done', () {
      expect(DayClock.statuses(at(23, 0)).values.toSet(), {SlotStatus.done});
    });

    test('greeting period follows the hour', () {
      expect(DayClock.period(at(7, 0)), DayPart.morning);
      expect(DayClock.period(at(12, 0)), DayPart.afternoon);
      expect(DayClock.period(at(18, 0)), DayPart.evening);
    });
  });

  group('FoodFilters', () {
    const foods = [
      FoodItem(
          id: '1',
          name: 'Chicken',
          description: 'grilled',
          calories: 165,
          protein: 31,
          carbs: 0,
          fat: 4),
      FoodItem(
          id: '2',
          name: 'Rice',
          description: 'brown',
          calories: 112,
          protein: 3,
          carbs: 23,
          fat: 1),
      FoodItem(
          id: '3',
          name: 'Oats',
          description: 'flakes',
          calories: 389,
          protein: 17,
          carbs: 66,
          fat: 7),
    ];

    List<String> names(FoodFilter f, [String q = '']) =>
        FoodFilters.apply(foods, f, q).map((e) => e.name).toList();

    test('quick filters', () {
      expect(names(FoodFilter.all), ['Chicken', 'Rice', 'Oats']);
      expect(names(FoodFilter.highProtein), ['Chicken', 'Oats']);
      expect(names(FoodFilter.lowCarb), ['Chicken']);
      expect(names(FoodFilter.light), ['Rice']);
    });

    test('query matches name or description, ignoring case', () {
      expect(names(FoodFilter.all, 'BROWN'), ['Rice']);
      expect(names(FoodFilter.highProtein, 'oat'), ['Oats']);
      expect(names(FoodFilter.all, '  '), ['Chicken', 'Rice', 'Oats']);
    });
  });
}
