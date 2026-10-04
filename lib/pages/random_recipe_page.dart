import 'package:flutter/material.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import '../services/api_service.dart';
import 'package:webdiet/widgets/random_recipe_content.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          l10n.randomRecipeTitle,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
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
                  Icon(Icons.error_outline, size: 48, color: colorScheme.error),
                  const SizedBox(height: 16),
                  Text(
                    '${l10n.randomRecipeErrorPrefix}${l10n.recipeLoadError}',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _refreshRecipe,
                    icon: const Icon(Icons.refresh),
                    label: Text(l10n.randomRecipeRetry),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            final meal = snapshot.data!;
            return RandomRecipeContent(meal: meal, onRefresh: _refreshRecipe);
          } else {
            return Center(child: Text(l10n.randomRecipeNoData));
          }
        },
      ),
    );
  }
}
