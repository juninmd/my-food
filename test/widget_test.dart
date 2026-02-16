// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:my_food/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify Dashboard Title (localized "Dashboard")
    expect(find.text('Dashboard'), findsAtLeastNWidgets(1));
    // Verify "Hello!"
    expect(find.text('Hello!'), findsOneWidget);

    // Verify that Total Calories is displayed
    // "Remaining" text in NutrientRing
    expect(find.text('Remaining'), findsOneWidget);

    // Verify that Me Surpreenda button DOES exist on Dashboard.
    expect(find.byIcon(Icons.auto_awesome), findsOneWidget);
  });
}
