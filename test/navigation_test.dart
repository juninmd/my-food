import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webdiet/main.dart';
import 'package:webdiet/pages/bmi_page.dart';
import 'package:webdiet/pages/food_catalog_page.dart';
import 'package:webdiet/widgets/shopping_list_view.dart';
import 'package:webdiet/widgets/tools_view.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Navigation to BMI Calculator Page via Tools Tab',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.handyman_outlined));
    await tester.pumpAndSettle();
    expect(find.byType(ToolsView), findsOneWidget);

    await tester.tap(find.text('BMI Calculator'));
    await tester.pumpAndSettle();
    expect(find.byType(BMICalculatorPage), findsOneWidget);
  });

  testWidgets('Navigation to Shopping List via Tab',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.shopping_bag_outlined));
    await tester.pumpAndSettle();

    expect(find.byType(ShoppingListView), findsOneWidget);
    expect(find.text('Shopping List'), findsAtLeastNWidgets(1));
  });

  testWidgets('Tools catalog shortcut switches to the Catalog tab',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.handyman_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Manage your custom foods'));
    await tester.pumpAndSettle();

    expect(find.byType(FoodCatalogPage), findsOneWidget);
  });

  testWidgets('Market badge counts ingredients left to buy',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    // Default plan: Bread with Egg, Chicken & Sweet Potato, Vegetable Soup.
    expect(find.text('12'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.shopping_bag_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Butter'));
    await tester.pumpAndSettle();

    expect(find.text('11'), findsOneWidget);
  });
}
