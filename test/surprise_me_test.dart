import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webdiet/pages/home_page.dart';
import 'package:webdiet/services/api_service.dart';

import 'helpers/localized_app.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget createLocalizedContext(Widget child) => localizedApp(child);

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
    await tester.pumpWidget(createLocalizedContext(
      HomePage(apiService: apiService),
    ));

    // Wait for the initial future to complete
    await tester.pumpAndSettle();

    // Verify first quote is displayed on Dashboard
    // The quote is near the top, so we shouldn't need to scroll.
    final firstQuoteFinder = find.text('"First Quote" - Author 1');
    expect(firstQuoteFinder, findsOneWidget);

    // Open the Tools tab and start Surprise Me from there.
    await tester.tap(find.byIcon(Icons.handyman_outlined));
    await tester.pumpAndSettle();
    expect(find.text('AI Recommendation'), findsOneWidget);
    await tester.tap(find.text('AI Recommendation'));

    // The slot spins on the Today tab, then lands on the best combination.
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Meal plan randomized! Check out the new quote.'),
        findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.text('"Second Quote" - Author 2'), findsOneWidget);
    expect(firstQuoteFinder, findsNothing);

    // The plan closest to 2430 kcal uses the richest option of each meal.
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getInt('breakfast_index'), 0);
    expect(prefs.getInt('lunch_index'), 0);
    expect(prefs.getInt('dinner_index'), 1);
  });

  testWidgets('Surprise Me displays fallback message on API error',
      (WidgetTester tester) async {
    final client = MockClient((request) async {
      return http.Response('Error', 500);
    });

    final apiService = ApiService(client: client);

    await tester.pumpWidget(createLocalizedContext(
      HomePage(apiService: apiService),
    ));

    await tester.pumpAndSettle();

    // Verify fallback message is displayed
    final fallbackFinder = find.text('Keep focused and healthy!');
    // Again, assume visibility at top
    expect(fallbackFinder, findsOneWidget);
  });
}
