import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:my_food/pages/random_recipe_page.dart';
import 'package:my_food/services/api_service.dart';

void main() {
  testWidgets('RandomRecipePage shows loading indicator initially', (WidgetTester tester) async {
    final completer = Completer<http.Response>();
    final client = MockClient((request) => completer.future);
    final apiService = ApiService(client: client);

    await tester.pumpWidget(MaterialApp(
      home: RandomRecipePage(apiService: apiService),
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

    await tester.pumpWidget(MaterialApp(
      home: RandomRecipePage(apiService: apiService),
    ));

    // Wait for Future to complete
    await tester.pumpAndSettle();

    expect(find.text('Spaghetti Carbonara'), findsOneWidget);
    expect(find.text('Categoria: Pasta'), findsOneWidget);
    expect(find.text('Boil pasta. Fry bacon. Mix with eggs and cheese.'), findsOneWidget);
    expect(find.text('Nova Receita'), findsOneWidget);
    // Image.network is tricky to test as it loads asynchronously and depends on network,
    // but in widget tests with MockClient it might try to load.
    // Flutter test environment usually intercepts HTTP calls from Image.network and returns 400 or similar
    // unless mocked deeply (HttpOverrides).
    // But since we are mocking ApiService, the Image.network is separate.
    // However, the test focuses on text content which validates the logic.
  });

  testWidgets('RandomRecipePage displays error message and retry button on failure', (WidgetTester tester) async {
    final client = MockClient((request) async {
      return http.Response('Internal Server Error', 500);
    });

    final apiService = ApiService(client: client);

    await tester.pumpWidget(MaterialApp(
      home: RandomRecipePage(apiService: apiService),
    ));

    await tester.pumpAndSettle();

    // ApiService wraps all errors in 'Exception: Erro de conexão.'
    expect(find.textContaining('Erro de conexão'), findsOneWidget);
    expect(find.text('Tentar Novamente'), findsOneWidget);
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

    await tester.pumpWidget(MaterialApp(
      home: RandomRecipePage(apiService: apiService),
    ));

    await tester.pumpAndSettle();

    // First attempt failed
    expect(find.text('Tentar Novamente'), findsOneWidget);

    // Tap retry
    await tester.tap(find.text('Tentar Novamente'));
    await tester.pump(); // Start future
    await tester.pumpAndSettle(); // Resolve future

    // Second attempt succeeded
    expect(find.text('Spaghetti Carbonara'), findsOneWidget);
  });
}
