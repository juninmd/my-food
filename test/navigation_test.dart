import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_food/main.dart';
import 'package:my_food/pages/bmi_page.dart';
import 'package:my_food/pages/shopping_list_page.dart';

void main() {
  testWidgets('Navigation to BMI Calculator Page via Drawer', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Open Drawer
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();

    // Verify Drawer is open and find BMI item
    expect(find.text('Calculadora IMC'), findsOneWidget);

    // Tap BMI item
    await tester.tap(find.text('Calculadora IMC'));
    await tester.pumpAndSettle();

    // Verify we are on BMI Page
    expect(find.byType(BMICalculatorPage), findsOneWidget);
    expect(find.text('Calculadora IMC'), findsOneWidget);
  });

  testWidgets('Navigation to Shopping List Page via Action', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Find Shopping Cart icon
    expect(find.byIcon(Icons.shopping_cart), findsOneWidget);

    // Tap it
    await tester.tap(find.byIcon(Icons.shopping_cart));
    await tester.pumpAndSettle();

    // Verify we are on Shopping List Page
    expect(find.byType(ShoppingListPage), findsOneWidget);
    expect(find.text('Lista de Compras'), findsOneWidget);
  });
}
