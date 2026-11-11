import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webdiet/models/food_item.dart';
import 'package:webdiet/pages/food_catalog_page.dart';

import 'helpers/localized_app.dart';

void main() {
  const apple = FoodItem(
    id: '1',
    name: 'Custom Apple',
    description: 'A very custom apple',
    calories: 100,
    protein: 1,
    carbs: 20,
    fat: 0,
  );
  const chicken = FoodItem(
    id: '2',
    name: 'Grilled Chicken',
    description: '100 g',
    calories: 165,
    protein: 31,
    carbs: 0,
    fat: 4,
  );

  void seed(List<FoodItem> foods) => SharedPreferences.setMockInitialValues(
      {'custom_foods': json.encode(foods.map((f) => f.toJson()).toList())});

  testWidgets('displays empty state when no foods exist', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(localizedApp(const FoodCatalogPage()));
    await tester.pumpAndSettle();

    expect(find.text('No custom foods added yet.'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('displays food items correctly', (tester) async {
    seed([apple]);
    await tester.pumpWidget(localizedApp(const FoodCatalogPage()));
    await tester.pumpAndSettle();

    expect(find.text('Custom Apple'), findsOneWidget);
    expect(find.text('A very custom apple'), findsOneWidget);
    expect(find.text('100'), findsOneWidget);
    expect(find.text('P1g · C20g · F0g'), findsOneWidget);
  });

  testWidgets('search and filters narrow the grid', (tester) async {
    seed([apple, chicken]);
    await tester.pumpWidget(localizedApp(const FoodCatalogPage()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('High protein'));
    await tester.pumpAndSettle();
    expect(find.text('Grilled Chicken'), findsOneWidget);
    expect(find.text('Custom Apple'), findsNothing);

    await tester.tap(find.text('All'));
    await tester.enterText(find.byType(TextField), 'apple');
    await tester.pumpAndSettle();
    expect(find.text('Custom Apple'), findsOneWidget);
    expect(find.text('Grilled Chicken'), findsNothing);

    await tester.enterText(find.byType(TextField), 'pizza');
    await tester.pumpAndSettle();
    expect(find.text('No foods found.'), findsOneWidget);
  });

  testWidgets('delete needs a second tap and can be undone', (tester) async {
    seed([apple]);
    await tester.pumpWidget(localizedApp(const FoodCatalogPage()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Custom Apple'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete Food'));
    await tester.pumpAndSettle();
    expect(find.text('Tap again to delete'), findsOneWidget);

    await tester.tap(find.text('Tap again to delete'));
    await tester.pumpAndSettle();
    expect(find.text('No custom foods added yet.'), findsOneWidget);
    expect(find.text('Custom Apple deleted'), findsOneWidget);

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(find.text('Custom Apple'), findsOneWidget);
  });
}
