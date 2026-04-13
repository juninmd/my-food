import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';
import 'package:my_food/models/food_item.dart';
import 'package:my_food/services/food_service.dart';
import 'package:my_food/pages/food_form_page.dart';
import 'package:my_food/widgets/food_catalog_card.dart';

class FoodCatalogPage extends StatefulWidget {
  const FoodCatalogPage({super.key});

  @override
  State<FoodCatalogPage> createState() => _FoodCatalogPageState();
}

class _FoodCatalogPageState extends State<FoodCatalogPage> {
  final FoodService _foodService = FoodService();
  List<FoodItem> _foods = [];
  bool _isLoading = true;

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
      _isLoading = false;
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
          SliverAppBar(
            expandedHeight: 120.0,
            floating: true,
            pinned: true,
            backgroundColor: colorScheme.surface,
            iconTheme: IconThemeData(color: colorScheme.onSurface),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
              title: Text(
                l10n.foodCatalogTitle,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_foods.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Text(
                  l10n.noFoodsYet,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
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
                    final food = _foods[index];
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
                  childCount: _foods.length,
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
