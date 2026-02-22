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
    final firstQuoteFinder = find.text('"First Quote" - Author 1');
    await tester.scrollUntilVisible(firstQuoteFinder, 500.0, scrollable: find.byType(Scrollable));
    expect(firstQuoteFinder, findsOneWidget);

    // Tap Tools tab
    await tester.tap(find.byIcon(Icons.grid_view));
    await tester.pumpAndSettle();

    // Verify Surprise Me button exists
    expect(find.text('Surprise Me'), findsOneWidget);

    // Tap Surprise Me button
    await tester.tap(find.text('Surprise Me'));

    // Pump to start the future and navigation
    await tester.pump();

    // Wait for the second future to complete and navigation
    await tester.pumpAndSettle();

    // Verify we are back on Dashboard (Dashboard icon is selected/active)
    // Or just check for the quote
    final secondQuoteFinder = find.text('"Second Quote" - Author 2');
    await tester.scrollUntilVisible(secondQuoteFinder, 500.0, scrollable: find.byType(Scrollable));
    expect(secondQuoteFinder, findsOneWidget);

    // Verify SnackBar is displayed
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Meal plan randomized! Check out the new quote.'),
        findsOneWidget);
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
    await tester.scrollUntilVisible(fallbackFinder, 500.0, scrollable: find.byType(Scrollable));
    expect(fallbackFinder, findsOneWidget);
  });
}
