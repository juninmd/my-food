import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:my_food/services/api_service.dart';
import 'dart:convert';

void main() {
  group('ApiService Tests', () {
    test('fetchQuote returns quote when call is successful', () async {
      final client = MockClient((request) async {
        if (request.url.toString() == ApiService.quoteUrl) {
          return http.Response(jsonEncode({'quote': 'Test Quote', 'author': 'Test Author'}), 200);
        }
        return http.Response('Not Found', 404);
      });

      final apiService = ApiService(client: client);
      final quote = await apiService.fetchQuote();

      expect(quote, equals('"Test Quote" - Test Author'));
    });

    test('fetchQuote throws exception on error', () async {
      final client = MockClient((request) async {
        return http.Response('Error', 500);
      });

      final apiService = ApiService(client: client);

      expect(apiService.fetchQuote(), throwsException);
    });

    test('fetchQuote throws exception on network error', () async {
      final client = MockClient((request) async {
        throw Exception('Network Error');
      });

      final apiService = ApiService(client: client);

      expect(apiService.fetchQuote(), throwsException);
    });

    test('fetchRandomRecipe returns meal when call is successful', () async {
      final mockMeal = {
        'idMeal': '12345',
        'strMeal': 'Test Meal',
        'strCategory': 'Test Category'
      };

      final client = MockClient((request) async {
        if (request.url.toString() == ApiService.mealUrl) {
          return http.Response(jsonEncode({'meals': [mockMeal]}), 200);
        }
        return http.Response('Not Found', 404);
      });

      final apiService = ApiService(client: client);
      final meal = await apiService.fetchRandomRecipe();

      expect(meal['strMeal'], equals('Test Meal'));
    });

    test('fetchRandomRecipe throws exception on error', () async {
      final client = MockClient((request) async {
        return http.Response('Error', 500);
      });

      final apiService = ApiService(client: client);

      expect(apiService.fetchRandomRecipe(), throwsException);
    });
  });
}
