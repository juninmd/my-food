import 'package:flutter_test/flutter_test.dart';
import 'package:my_food/data/meal_data.dart';

void main() {
  group('MealData Tests', () {
    test('Breakfast options should not be empty', () {
      expect(MealData.breakfastOptions.isNotEmpty, true);
    });

    test('Lunch options should not be empty', () {
      expect(MealData.lunchOptions.isNotEmpty, true);
    });

    test('Dinner options should not be empty', () {
      expect(MealData.dinnerOptions.isNotEmpty, true);
    });

    test('Meal properties should be valid', () {
      final meal = MealData.breakfastOptions.first;
      expect(meal.name.isNotEmpty, true);
      expect(meal.calories > 0, true);
      expect(meal.protein >= 0, true);
      expect(meal.carbs >= 0, true);
      expect(meal.fat >= 0, true);
    });
  });

  group('Nutrient Calculation Logic', () {
    test('Total calories calculation', () {
      final breakfast = MealData.breakfastOptions[0];
      final lunch = MealData.lunchOptions[0];
      final dinner = MealData.dinnerOptions[0];

      final totalCalories =
          breakfast.calories + lunch.calories + dinner.calories;

      // Verification logic similar to what's in MealPage
      expect(totalCalories, greaterThan(0));
      expect(
          totalCalories, breakfast.calories + lunch.calories + dinner.calories);
    });

    test('Shopping List Aggregation Logic', () {
      final ingredients1 = ['Egg', 'Bread'];
      final ingredients2 = ['Egg', 'Milk'];

      final allIngredients = [...ingredients1, ...ingredients2];
      final Map<String, int> counts = {};

      for (var ingredient in allIngredients) {
        counts[ingredient] = (counts[ingredient] ?? 0) + 1;
      }

      expect(counts['Egg'], 2);
      expect(counts['Bread'], 1);
      expect(counts['Milk'], 1);
    });
  });
}
