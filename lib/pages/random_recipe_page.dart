import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RandomRecipePage extends StatefulWidget {
  const RandomRecipePage({super.key});

  @override
  State<RandomRecipePage> createState() => _RandomRecipePageState();
}

class _RandomRecipePageState extends State<RandomRecipePage> {
  final ApiService _apiService = ApiService();
  late Future<Map<String, dynamic>> _recipeFuture;

  @override
  void initState() {
    super.initState();
    _recipeFuture = _apiService.fetchRandomRecipe();
  }

  void _refreshRecipe() {
    setState(() {
      _recipeFuture = _apiService.fetchRandomRecipe();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receita Surpresa'),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _recipeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Erro: ${snapshot.error}'),
                  ElevatedButton(
                    onPressed: _refreshRecipe,
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            final meal = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (meal['strMealThumb'] != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        meal['strMealThumb'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 200,
                            color: Colors.grey,
                            child: const Center(child: Icon(Icons.broken_image, size: 50)),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    meal['strMeal'] ?? 'Sem nome',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Categoria: ${meal['strCategory'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Instruções:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    meal['strInstructions'] ?? 'Sem instruções disponíveis.',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _refreshRecipe,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Nova Receita'),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Nenhum dado encontrado.'));
          }
        },
      ),
    );
  }
}
