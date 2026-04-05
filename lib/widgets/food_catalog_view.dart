import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';
import 'package:my_food/models/food.dart';
import 'package:my_food/services/food_service.dart';
import 'package:my_food/pages/food_form_page.dart';

class FoodCatalogView extends StatefulWidget {
  const FoodCatalogView({super.key});

  @override
  State<FoodCatalogView> createState() => _FoodCatalogViewState();
}

class _FoodCatalogViewState extends State<FoodCatalogView> {
  final FoodService _foodService = FoodService();
  List<Food> _foods = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFoods();
  }

  Future<void> _loadFoods() async {
    setState(() {
      _isLoading = true;
    });
    final foods = await _foodService.getFoods();
    setState(() {
      _foods = foods;
      _isLoading = false;
    });
  }

  void _navigateToAddFood() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FoodFormPage()),
    );
    if (result == true) {
      _loadFoods();
    }
  }

  void _navigateToEditFood(Food food) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FoodFormPage(food: food)),
    );
    if (result == true) {
      _loadFoods();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Note: To be fully localized, add these keys to ARB files later.
    // For now, falling back to English strings if l10n is not ready.
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    final l10n = AppLocalizations.of(context)!;
    String title = l10n.foodCatalogTitle;
    String emptyMsg = l10n.foodCatalogEmpty;

    return Scaffold(
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
              titlePadding: const EdgeInsets.only(left: 48, bottom: 16), // Adjusted for back button
              title: Text(
                title,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
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
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.restaurant_menu,
                          size: 64, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text(
                        emptyMsg,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final food = _foods[index];
                    return _buildFoodCard(context, food);
                  },
                  childCount: _foods.length,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddFood,
        backgroundColor: colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildFoodCard(BuildContext context, Food food) {
    return FoodCard(
      food: food,
      onTap: () => _navigateToEditFood(food),
    );
  }
}

class FoodCard extends StatelessWidget {
  final Food food;
  final VoidCallback onTap;

  const FoodCard({super.key, required this.food, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget imageWidget = (food.imagePath.isNotEmpty && !food.imagePath.startsWith('assets/'))
        ? Image.file(File(food.imagePath), fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image))
        : Image.asset(food.imagePath.isNotEmpty ? food.imagePath : 'assets/images/lanche.jpg', fit: BoxFit.cover);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 24, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                ClipRRect(borderRadius: BorderRadius.circular(16), child: SizedBox(width: 80, height: 80, child: imageWidget)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(food.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text(food.category, style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildPill(theme, '${food.calories}kcal', theme.colorScheme.primary),
                          const SizedBox(width: 8),
                          _buildPill(theme, 'P:${food.protein}g', Colors.blue),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPill(ThemeData theme, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
      child: Text(text, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
}
