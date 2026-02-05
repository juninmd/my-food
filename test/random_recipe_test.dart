import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:my_food/pages/random_recipe_page.dart';
import 'package:my_food/services/api_service.dart';

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

  testWidgets('RandomRecipePage shows loading indicator initially', (WidgetTester tester) async {
    final completer = Completer<http.Response>();
    final client = MockClient((request) => completer.future);
    final apiService = ApiService(client: client);

    await tester.pumpWidget(createLocalizedContext(
      RandomRecipePage(apiService: apiService),
    ));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete(http.Response(jsonEncode({'meals': []}), 200));
    await tester.pumpAndSettle();
  });

  testWidgets('RandomRecipePage displays recipe details when API call is successful', (WidgetTester tester) async {
    final mockMeal = {
      'idMeal': '123',
      'strMeal': 'Spaghetti Carbonara',
      'strCategory': 'Pasta',
      'strInstructions': 'Boil pasta. Fry bacon. Mix with eggs and cheese.',
      'strMealThumb': 'https://example.com/spaghetti.jpg',
    };

    final client = MockClient((request) async {
      if (request.url.toString() == ApiService.mealUrl) {
        return http.Response(jsonEncode({'meals': [mockMeal]}), 200);
      }
      return http.Response('Not Found', 404);
    });

    final apiService = ApiService(client: client);

    await tester.pumpWidget(createLocalizedContext(
      RandomRecipePage(apiService: apiService),
    ));

    // Wait for Future to complete
    await tester.pumpAndSettle();

    expect(find.text('Spaghetti Carbonara'), findsOneWidget);
    // "Category: " is from l10n (English), "Pasta" is from API
    expect(find.text('Category: Pasta'), findsOneWidget);
    expect(find.text('Boil pasta. Fry bacon. Mix with eggs and cheese.'), findsOneWidget);
    // "New Recipe" from l10n
    expect(find.text('New Recipe'), findsOneWidget);
  });

  testWidgets('RandomRecipePage displays error message and retry button on failure', (WidgetTester tester) async {
    final client = MockClient((request) async {
      return http.Response('Internal Server Error', 500);
    });

    final apiService = ApiService(client: client);

    await tester.pumpWidget(createLocalizedContext(
      RandomRecipePage(apiService: apiService),
    ));

    await tester.pumpAndSettle();

    // ApiService wraps all errors in 'Exception: Erro de conexão.' (Hardcoded PT)
    expect(find.textContaining('Erro de conexão'), findsOneWidget);
    // "Try Again" from l10n
    expect(find.text('Try Again'), findsOneWidget);
  });

  testWidgets('RandomRecipePage retry button triggers new fetch', (WidgetTester tester) async {
     var callCount = 0;
     final mockMeal = {
      'idMeal': '123',
      'strMeal': 'Spaghetti Carbonara',
      'strCategory': 'Pasta',
      'strInstructions': 'Instructions',
    };

    final client = MockClient((request) async {
      callCount++;
      if (callCount == 1) {
        return http.Response('Error', 500);
      } else {
        return http.Response(jsonEncode({'meals': [mockMeal]}), 200);
      }
    });

    final apiService = ApiService(client: client);

    await tester.pumpWidget(createLocalizedContext(
      RandomRecipePage(apiService: apiService),
    ));

    await tester.pumpAndSettle();

    // First attempt failed
    expect(find.text('Try Again'), findsOneWidget);

    // Tap retry
    await tester.tap(find.text('Try Again'));
    await tester.pump(); // Start future
    await tester.pumpAndSettle(); // Resolve future

    // Second attempt succeeded
    expect(find.text('Spaghetti Carbonara'), findsOneWidget);
  });
}
