import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';
import 'package:my_food/models/food_item.dart';
import 'package:my_food/services/food_service.dart';
import 'package:my_food/pages/food_form_page.dart';

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
      appBar: AppBar(
        title: Text(
          l10n.foodCatalogTitle,
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _foods.isEmpty
              ? Center(
                  child: Text(
                    l10n.noFoodsYet,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(24.0),
                  itemCount: _foods.length,
                  itemBuilder: (context, index) {
                    final food = _foods[index];
                    return _buildFoodCard(context, food, l10n);
                  },
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

  Widget _buildFoodCard(
      BuildContext context, FoodItem food, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FoodFormPage(foodToEdit: food),
              ),
            );
            _loadFoods();
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    image: food.imageBase64 != null
                        ? DecorationImage(
                            image: MemoryImage(base64Decode(food.imageBase64!)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: food.imageBase64 == null
                      ? Icon(Icons.fastfood_outlined,
                          color: colorScheme.primary, size: 32)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              food.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_outline,
                                color: colorScheme.error, size: 20),
                            onPressed: () {
                              _showDeleteDialog(context, food.id, l10n);
                            },
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        food.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          _buildMacroBadge(
                              context,
                              '${food.calories} kcal',
                              Colors.orange.shade800,
                              Colors.orange.withValues(alpha: 0.1)),
                          _buildMacroBadge(
                              context,
                              '${food.protein}g P',
                              colorScheme.primary,
                              colorScheme.primary.withValues(alpha: 0.1)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMacroBadge(
      BuildContext context, String text, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context, String foodId, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(l10n.deleteFood),
        content: Text(l10n.deleteConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'), // TODO: localize
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              _deleteFood(foodId);
            },
            child: Text(l10n.deleteFood),
          ),
        ],
      ),
    );
  }
}
