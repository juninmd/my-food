// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_food/main.dart';

void main() {
  testWidgets('App loads and shows MealPage with Surprise Me button', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the title "Alimentação" is present.
    expect(find.text('Alimentação'), findsOneWidget);

    // Verify that the nutrient summary is present (e.g. "Resumo Diário")
    expect(find.text('Resumo Diário'), findsOneWidget);

    // Verify that navigation bar is present
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Verify Surprise Me button exists
    expect(find.byTooltip('Me Surpreenda'), findsOneWidget);
  });
}
