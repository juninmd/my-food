import 'package:flutter/material.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';
import '../services/api_service.dart';

class RandomRecipePage extends StatefulWidget {
  final ApiService? apiService;

  const RandomRecipePage({super.key, this.apiService});

  @override
  State<RandomRecipePage> createState() => _RandomRecipePageState();
}

class _RandomRecipePageState extends State<RandomRecipePage> {
  late ApiService _apiService;
  late Future<Map<String, dynamic>> _recipeFuture;

  @override
  void initState() {
    super.initState();
    _apiService = widget.apiService ?? ApiService();
    _recipeFuture = _apiService.fetchRandomRecipe();
  }

  void _refreshRecipe() {
    setState(() {
      _recipeFuture = _apiService.fetchRandomRecipe();
    });
  }

  @override
  void dispose() {
    if (widget.apiService == null) {
      _apiService.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.randomRecipeTitle),
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
                  Text(
                      '${l10n.randomRecipeErrorPrefix}${l10n.recipeLoadError}'),
                  ElevatedButton(
                    onPressed: _refreshRecipe,
                    child: Text(l10n.randomRecipeRetry),
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
                            child: const Center(
                                child: Icon(Icons.broken_image, size: 50)),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    meal['strMeal'] ?? l10n.randomRecipeNoName,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${l10n.randomRecipeCategoryPrefix}${meal['strCategory'] ?? l10n.randomRecipeNA}',
                    style: const TextStyle(
                        fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.randomRecipeInstructions,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    meal['strInstructions'] ?? l10n.randomRecipeNoInstructions,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _refreshRecipe,
                      icon: const Icon(Icons.refresh),
                      label: Text(l10n.randomRecipeNew),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text(l10n.randomRecipeNoData));
          }
        },
      ),
    );
  }
}
