import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';
import 'package:my_food/pages/food_form_page.dart';
import 'package:my_food/models/food_item.dart';

void main() {
  Widget createLocalizedContext(Widget child) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: child,
    );
  }

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('FoodFormPage renders add mode correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createLocalizedContext(const FoodFormPage()));
    await tester.pumpAndSettle();

    expect(find.text('Add Food'), findsOneWidget);
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
    expect(find.text('Calories'), findsOneWidget);
    expect(find.text('Protein (g)'), findsOneWidget);
    expect(find.text('Save Food'), findsOneWidget);
  });

  testWidgets('FoodFormPage renders edit mode correctly with existing data', (WidgetTester tester) async {
    final food = FoodItem(
      id: '1',
      name: 'Custom Apple',
      description: 'A very custom apple',
      calories: 100,
      protein: 1,
      carbs: 20,
      fat: 0,
    );

    await tester.pumpWidget(createLocalizedContext(FoodFormPage(foodToEdit: food)));
    await tester.pumpAndSettle();

    expect(find.text('Edit Food'), findsOneWidget);
    expect(find.text('Custom Apple'), findsOneWidget);
    expect(find.text('A very custom apple'), findsOneWidget);
    expect(find.text('100'), findsOneWidget);
  });

  testWidgets('FoodFormPage shows validation errors on empty required fields', (WidgetTester tester) async {
    await tester.pumpWidget(createLocalizedContext(const FoodFormPage()));
    await tester.pumpAndSettle();

    // Ensure we can see the button by scrolling down if necessary
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -500));
    await tester.pumpAndSettle();

    // Tap save without entering anything
    await tester.tap(find.text('Save Food'));
    await tester.pumpAndSettle();

    expect(find.text('Required'), findsOneWidget);
  });

  testWidgets('FoodFormPage saves food successfully and pops', (WidgetTester tester) async {
    await tester.pumpWidget(createLocalizedContext(const FoodFormPage()));
    await tester.pumpAndSettle();

    // Enter name
    await tester.enterText(find.byType(TextFormField).first, 'New Pizza');
    // Enter description
    await tester.enterText(find.byType(TextFormField).at(1), 'Delicious');
    // Enter calories
    await tester.enterText(find.byType(TextFormField).at(2), '300');

    // Ensure we can see the button by scrolling down if necessary
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -500));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save Food'));
    await tester.pumpAndSettle();

    // Verify we popped out
    expect(find.byType(FoodFormPage), findsNothing);

    // Verify it was saved to shared preferences
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('custom_foods');
    expect(jsonString, isNotNull);

    final foods = json.decode(jsonString!) as List;
    expect(foods.length, 1);
    expect(foods[0]['name'], 'New Pizza');
    expect(foods[0]['calories'], 300);
  });
}
