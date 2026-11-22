import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service responsible for fetching data from external APIs.
///
/// This service handles requests to fetch random quotes and meal recipes.
class ApiService {
  static const String quoteUrl = 'https://dummyjson.com/quotes/random';
  static const String mealUrl =
      'https://www.themealdb.com/api/json/v1/1/random.php';

  /// Upper bound for a single request so the UI never spins forever offline.
  static const Duration requestTimeout = Duration(seconds: 10);

  final http.Client client;

  /// Creates an instance of [ApiService].
  ///
  /// Optionally accepts an [http.Client] for testing purposes.
  ApiService({http.Client? client}) : client = client ?? http.Client();

  /// Fetches a random quote from the dummyjson API.
  ///
  /// Returns a formatted string with the quote and author.
  /// Throws an [Exception] if the request fails or an error occurs.
  Future<String> fetchQuote() async {
    try {
      final response =
          await client.get(Uri.parse(quoteUrl)).timeout(requestTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final quote = data is Map ? data['quote'] : null;
        final author = data is Map ? data['author'] : null;
        // A 200 with another shape must not show `"null" - null` as a quote.
        if (quote is! String || quote.isEmpty || author is! String) {
          throw Exception('Failed to load quote');
        }
        return '"$quote" - $author';
      } else {
        throw Exception('Failed to load quote');
      }
    } catch (e) {
      if (e.toString().contains('Failed to load quote')) rethrow;
      throw Exception('Connection error');
    }
  }

  /// Fetches a random recipe from the Themealdb API.
  ///
  /// Returns a [Map] containing the meal data.
  /// Throws an [Exception] if the request fails or an error occurs.
  Future<Map<String, dynamic>> fetchRandomRecipe() async {
    try {
      final response =
          await client.get(Uri.parse(mealUrl)).timeout(requestTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final meals = data is Map ? data['meals'] : null;
        // TheMealDB answers `{"meals": null}` when it has nothing to serve.
        if (meals is! List || meals.isEmpty || meals.first is! Map) {
          throw Exception('Failed to load recipe');
        }
        return Map<String, dynamic>.from(meals.first as Map);
      } else {
        throw Exception('Failed to load recipe');
      }
    } catch (e) {
      if (e.toString().contains('Failed to load recipe')) rethrow;
      throw Exception('Connection error');
    }
  }

  /// Closes the underlying HTTP client.
  void dispose() {
    client.close();
  }
}
