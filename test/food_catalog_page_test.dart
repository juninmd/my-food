import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';
import 'package:my_food/models/food_item.dart';
import 'package:my_food/pages/food_catalog_page.dart';

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

  testWidgets('FoodCatalogPage displays empty state when no foods exist', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(createLocalizedContext(const FoodCatalogPage()));

    // Wait for the Future to complete and the widget to rebuild
    await tester.pumpAndSettle();

    expect(find.text('No custom foods added yet.'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('FoodCatalogPage displays food items correctly', (WidgetTester tester) async {
    final food = FoodItem(
      id: '1',
      name: 'Custom Apple',
      description: 'A very custom apple',
      calories: 100,
      protein: 1,
      carbs: 20,
      fat: 0,
    );

    final String encodedList = json.encode([food.toJson()]);
    SharedPreferences.setMockInitialValues({'custom_foods': encodedList});

    await tester.pumpWidget(createLocalizedContext(const FoodCatalogPage()));
    await tester.pumpAndSettle();

    expect(find.text('Custom Apple'), findsOneWidget);
    expect(find.text('A very custom apple'), findsOneWidget);
    expect(find.text('100 kcal'), findsOneWidget);
    expect(find.text('1g P'), findsOneWidget);
  });

  testWidgets('FoodCatalogPage delete button shows dialog and deletes item', (WidgetTester tester) async {
    final food = FoodItem(
      id: '1',
      name: 'Custom Apple',
      description: 'A very custom apple',
      calories: 100,
      protein: 1,
      carbs: 20,
      fat: 0,
    );

    final String encodedList = json.encode([food.toJson()]);
    SharedPreferences.setMockInitialValues({'custom_foods': encodedList});

    await tester.pumpWidget(createLocalizedContext(const FoodCatalogPage()));
    await tester.pumpAndSettle();

    expect(find.text('Custom Apple'), findsOneWidget);

    // Tap the delete icon
    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();

    // Verify dialog appears
    expect(find.text('Delete Food'), findsWidgets); // Title and Button
    expect(find.text('Are you sure you want to delete this food?'), findsOneWidget);

    // Tap delete button in dialog
    await tester.tap(find.widgetWithText(ElevatedButton, 'Delete Food'));
    await tester.pumpAndSettle();

    // Verify item is removed and empty state is shown
    expect(find.text('Custom Apple'), findsNothing);
    expect(find.text('No custom foods added yet.'), findsOneWidget);
  });
}
