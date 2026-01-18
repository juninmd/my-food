import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String quoteUrl = 'https://dummyjson.com/quotes/random';
  static const String mealUrl = 'https://www.themealdb.com/api/json/v1/1/random.php';

  Future<String> fetchQuote() async {
    try {
      final response = await http.get(Uri.parse(quoteUrl));

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

  Future<Map<String, dynamic>> fetchRandomRecipe() async {
    try {
      final response = await http.get(Uri.parse(mealUrl));

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
}
