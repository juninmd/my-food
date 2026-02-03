import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service responsible for fetching data from external APIs.
///
/// This service handles requests to fetch random quotes and meal recipes.
class ApiService {
  static const String quoteUrl = 'https://dummyjson.com/quotes/random';
  static const String mealUrl = 'https://www.themealdb.com/api/json/v1/1/random.php';

  final http.Client client;

  /// Creates an instance of [ApiService].
  ///
  /// Optionally accepts an [http.Client] for testing purposes.
  ApiService({http.Client? client}) : client = client ?? http.Client();

  /// Fetches a random quote from the dummyjson API.
  ///
  /// Returns a formatted string with the quote and author.
  /// Returns a default error message if the request fails or an exception occurs.
  Future<String> fetchQuote() async {
    try {
      final response = await client.get(Uri.parse(quoteUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return '"${data['quote']}" - ${data['author']}';
      } else {
        return 'Falha ao carregar frase.';
      }
    } catch (e) {
      return 'Mantenha-se focado e saudável!';
    }
  }

  /// Fetches a random recipe from the Themealdb API.
  ///
  /// Returns a [Map] containing the meal data.
  /// Throws an [Exception] if the request fails or an error occurs.
  Future<Map<String, dynamic>> fetchRandomRecipe() async {
    try {
      final response = await client.get(Uri.parse(mealUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final meal = data['meals'][0];
        return meal;
      } else {
        throw Exception('Falha ao carregar receita.');
      }
    } catch (e) {
      throw Exception('Erro de conexão.');
    }
  }

  /// Closes the underlying HTTP client.
  void dispose() {
    client.close();
  }
}
