import 'package:flutter/material.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/models/food_item.dart';
import 'package:webdiet/services/food_service.dart';
import 'package:webdiet/pages/food_form_page.dart';
import 'package:webdiet/widgets/food_catalog_card.dart';
import 'package:webdiet/widgets/food_catalog_empty_state.dart';
import 'package:webdiet/widgets/food_catalog_app_bar.dart';

class FoodCatalogPage extends StatefulWidget {
  const FoodCatalogPage({super.key});

  @override
  State<FoodCatalogPage> createState() => _FoodCatalogPageState();
}

class _FoodCatalogPageState extends State<FoodCatalogPage> {
  final FoodService _foodService = FoodService();
  List<FoodItem> _foods = [];
  List<FoodItem> _filteredFoods = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadFoods();
  }

  Future<void> _loadFoods() async {
    setState(() => _isLoading = true);
    final foods = await _foodService.getFoods();
    setState(() {
      _foods = foods;
      _filterFoods(_searchQuery);
      _isLoading = false;
    });
  }

  void _filterFoods(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredFoods = _foods;
      } else {
        _filteredFoods = _foods.where((food) {
          final lowerQuery = query.toLowerCase();
          return food.name.toLowerCase().contains(lowerQuery) ||
              food.description.toLowerCase().contains(lowerQuery);
        }).toList();
      }
    });
  }

  Future<void> _deleteFood(String id) async {
    await _foodService.deleteFood(id);
    _loadFoods();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          FoodCatalogAppBar(
            onFilterFoods: _filterFoods,
          ),
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_filteredFoods.isEmpty && _searchQuery.isEmpty)
            const FoodCatalogEmptyState()
          else if (_filteredFoods.isEmpty && _searchQuery.isNotEmpty)
            SliverFillRemaining(
              child: Center(
                child: Text(
                  l10n.noFoodsFound,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(24.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final food = _filteredFoods[index];
                    return FoodCatalogCard(
                      food: food,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FoodFormPage(foodToEdit: food),
                          ),
                        );
                        _loadFoods();
                      },
                      onDelete: () {
                        _deleteFood(food.id);
                      },
                    );
                  },
                  childCount: _filteredFoods.length,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FoodFormPage(),
            ),
          );
          _loadFoods();
        },
        backgroundColor: colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
