import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_food/main.dart';
import 'package:my_food/pages/bmi_page.dart';
import 'package:my_food/widgets/shopping_list_view.dart';
import 'package:my_food/widgets/tools_view.dart';

void main() {
  testWidgets('Navigation to BMI Calculator Page via Tools Tab',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Find Tools tab icon (Icons.grid_view is used for Tools tab)
    // Wait, inactive icon might be different.
    // HomePage: NavigationDestination(icon: const Icon(Icons.grid_view), ...
    // So it should be there.
    // Wait, BottomNavigationBar uses items: [BottomNavigationBarItem(icon: Icon(Icons.grid_view), ...)]

    await tester.tap(find.byIcon(Icons.grid_view));
    await tester.pumpAndSettle();

    // Verify Tools View
    expect(find.byType(ToolsView), findsOneWidget);

    // Tap BMI Card
    await tester.tap(find.text('BMI Calculator'));
    await tester.pumpAndSettle();

    // Verify we are on BMI Page
    expect(find.byType(BMICalculatorPage), findsOneWidget);
  });

  testWidgets('Navigation to Shopping List via Tab',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Find Shopping Cart icon (in BottomNav)
    // HomePage: BottomNavigationBarItem(icon: const Icon(Icons.shopping_cart_outlined), activeIcon: const Icon(Icons.shopping_cart), ...)
    // Initially inactive.

    await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
    await tester.pumpAndSettle();

    // Verify we are on Shopping List View
    expect(find.byType(ShoppingListView), findsOneWidget);
    expect(find.text('Shopping List'), findsAtLeastNWidgets(1));
  });
}
