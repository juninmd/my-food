import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_food/data/meal_data.dart';

void main() {
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

  group('MealData Tests', () {
    testWidgets('Breakfast options should not be empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(createLocalizedContext((context) {
        final l10n = AppLocalizations.of(context)!;
        expect(MealData.getBreakfastOptions(l10n).isNotEmpty, true);
        return const SizedBox();
      }));
    });

    testWidgets('Lunch options should not be empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(createLocalizedContext((context) {
        final l10n = AppLocalizations.of(context)!;
        expect(MealData.getLunchOptions(l10n).isNotEmpty, true);
        return const SizedBox();
      }));
    });

    testWidgets('Dinner options should not be empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(createLocalizedContext((context) {
        final l10n = AppLocalizations.of(context)!;
        expect(MealData.getDinnerOptions(l10n).isNotEmpty, true);
        return const SizedBox();
      }));
    });

    testWidgets('Meal properties should be valid', (WidgetTester tester) async {
      await tester.pumpWidget(createLocalizedContext((context) {
        final l10n = AppLocalizations.of(context)!;
        final meal = MealData.getBreakfastOptions(l10n).first;
        expect(meal.name.isNotEmpty, true);
        expect(meal.calories > 0, true);
        expect(meal.protein >= 0, true);
        expect(meal.carbs >= 0, true);
        expect(meal.fat >= 0, true);
        return const SizedBox();
      }));
    });
  });

  group('Nutrient Calculation Logic', () {
    testWidgets('Total calories calculation', (WidgetTester tester) async {
      await tester.pumpWidget(createLocalizedContext((context) {
        final l10n = AppLocalizations.of(context)!;
        final breakfast = MealData.getBreakfastOptions(l10n)[0];
        final lunch = MealData.getLunchOptions(l10n)[0];
        final dinner = MealData.getDinnerOptions(l10n)[0];

        final totalCalories =
            breakfast.calories + lunch.calories + dinner.calories;

        // Verification logic similar to what's in MealPage
        expect(totalCalories, greaterThan(0));
        expect(totalCalories,
            breakfast.calories + lunch.calories + dinner.calories);
        return const SizedBox();
      }));
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
