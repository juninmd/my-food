import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_food/pages/home_page.dart';
import 'package:my_food/services/api_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

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

    // Tap Tools tab (it might be at the bottom, but bottom nav bar is usually visible)
    await tester.tap(find.byIcon(Icons.grid_view));
    await tester.pumpAndSettle();

    // Verify Surprise Me button exists
    expect(find.text('AI Recommendation'), findsOneWidget);

    // Tap Surprise Me button
    await tester.tap(find.text('AI Recommendation'));

    // Pump to start the future and navigation
    await tester.pump();

    // Wait for the second future to complete and navigation
    await tester.pumpAndSettle();

    // The Dashboard updates in the background when onReveal is called.
    // The Dialog also displays the quote.
    // So we expect to find the quote twice.
    final secondQuoteFinder = find.text('"Second Quote" - Author 2');
    expect(secondQuoteFinder, findsNWidgets(2));

    // Verify Dialog feedback message
    expect(find.text('AI optimized meal plan! Check out the new quote.'),
        findsOneWidget);

    // Tap OK to close the dialog
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Verify we are back on Dashboard and only one quote exists
    expect(secondQuoteFinder, findsOneWidget);
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
