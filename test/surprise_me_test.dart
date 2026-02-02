import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:my_food/pages/meal_page.dart';
import 'package:my_food/services/api_service.dart';

void main() {
  testWidgets('Surprise Me button fetches new quote and updates UI',
      (WidgetTester tester) async {
    // Setup Mock Client with dynamic response
    var requestCount = 0;
    final client = MockClient((request) async {
      requestCount++;
      if (request.url.toString() == ApiService.quoteUrl) {
        if (requestCount == 1) {
          return http.Response(
              jsonEncode({'quote': 'First Quote', 'author': 'Author 1'}), 200);
        } else {
          return http.Response(
              jsonEncode({'quote': 'Second Quote', 'author': 'Author 2'}), 200);
        }
      }
      return http.Response('Not Found', 404);
    });

    final apiService = ApiService(client: client);

    // Pump widget with the injected ApiService
    await tester.pumpWidget(MaterialApp(
      home: MealPage(apiService: apiService),
    ));

    // Verify initial state
    expect(find.text('Me Surpreenda'), findsOneWidget);

    // Wait for the initial future to complete
    await tester.pumpAndSettle();

    // Verify first quote is displayed
    expect(find.text('"First Quote" - Author 1'), findsOneWidget);

    // Tap Surprise Me button
    await tester.tap(find.text('Me Surpreenda'));

    // Pump to start the future
    await tester.pump();

    // Wait for the second future to complete
    await tester.pumpAndSettle();

    // Verify second quote is displayed
    expect(find.text('"Second Quote" - Author 2'), findsOneWidget);
  });
}
