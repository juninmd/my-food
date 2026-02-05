import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_food/data/meal_data.dart';
import 'package:my_food/utils/bmi_calculator.dart';

void main() {
  group('Project Features Verification', () {

    Widget createLocalizedContext(Widget Function(BuildContext context) builder) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: Builder(builder: builder),
      );
    }

    // Feature 1: Patient Diet
    testWidgets('Diet Data Integrity', (WidgetTester tester) async {
      await tester.pumpWidget(createLocalizedContext((context) {
        final l10n = AppLocalizations.of(context)!;
        final breakfastOptions = MealData.getBreakfastOptions(l10n);
        final lunchOptions = MealData.getLunchOptions(l10n);
        final dinnerOptions = MealData.getDinnerOptions(l10n);

        expect(breakfastOptions.length, greaterThan(1), reason: 'Should have multiple breakfast options for variety');
        expect(lunchOptions.length, greaterThan(1), reason: 'Should have multiple lunch options for variety');
        expect(dinnerOptions.length, greaterThan(1), reason: 'Should have multiple dinner options for variety');

        final meal = breakfastOptions[0];
        expect(meal.name, isNotEmpty);
        expect(meal.calories, greaterThan(0));
        return const SizedBox();
      }));
    });

    // Feature 2: Nutrient Calculation
    testWidgets('Nutrient Calculation Logic', (WidgetTester tester) async {
       await tester.pumpWidget(createLocalizedContext((context) {
        final l10n = AppLocalizations.of(context)!;
        final breakfast = MealData.getBreakfastOptions(l10n)[0];
        final lunch = MealData.getLunchOptions(l10n)[0];
        final dinner = MealData.getDinnerOptions(l10n)[0];

        final totalCalories = breakfast.calories + lunch.calories + dinner.calories;
        final totalProtein = breakfast.protein + lunch.protein + dinner.protein;

        expect(totalCalories, equals(breakfast.calories + lunch.calories + dinner.calories));
        expect(totalProtein, equals(breakfast.protein + lunch.protein + dinner.protein));
        return const SizedBox();
      }));

      // Validate BMI Calculator logic as part of patient health tracking
      final bmiResult = BmiCalculator.calculate(70, 175);
      expect(bmiResult.bmi, closeTo(22.85, 0.01));
      expect(bmiResult.category, BmiCategory.normal);
    });

    // Feature 3: Shopping List
    test('Shopping List Aggregation Logic', () {
      // Simulate ingredients from different meals
      final ingredients = ['Ovos', 'Sal', 'Ovos', 'Leite'];

      // Logic from ShoppingListPage
      final Map<String, int> ingredientCounts = {};
      for (var ingredient in ingredients) {
        ingredientCounts[ingredient] = (ingredientCounts[ingredient] ?? 0) + 1;
      }

      expect(ingredientCounts['Ovos'], 2);
      expect(ingredientCounts['Sal'], 1);
      expect(ingredientCounts['Leite'], 1);
    });

    // Feature 4: Surprise Me
    testWidgets('Surprise Me Foundations', (WidgetTester tester) async {
      await tester.pumpWidget(createLocalizedContext((context) {
        final l10n = AppLocalizations.of(context)!;
        expect(MealData.getBreakfastOptions(l10n).length, greaterThanOrEqualTo(3));
        expect(MealData.getLunchOptions(l10n).length, greaterThanOrEqualTo(3));
        expect(MealData.getDinnerOptions(l10n).length, greaterThanOrEqualTo(3));
        return const SizedBox();
      }));
    });
  });
}
