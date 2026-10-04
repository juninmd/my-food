import 'package:flutter/material.dart';
import 'package:webdiet/widgets/shopping_list/shopping_list_item_tile.dart';

class ShoppingListCategory extends StatelessWidget {
  final String category;
  final List<String> ingredients;
  final Map<String, int> ingredientCounts;
  final Set<String> checkedIngredients;
  final Function(String, bool) onIngredientChecked;

  const ShoppingListCategory({
    super.key,
    required this.category,
    required this.ingredients,
    required this.ingredientCounts,
    required this.checkedIngredients,
    required this.onIngredientChecked,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: colorScheme.secondary,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                category.toUpperCase(),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.secondary,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: ingredients.map((ingredient) {
              final count = ingredientCounts[ingredient] ?? 1;
              final isChecked = checkedIngredients.contains(ingredient);
              final isLast = ingredient == ingredients.last;

              return ShoppingListItemTile(
                ingredient: ingredient,
                count: count,
                isChecked: isChecked,
                isLast: isLast,
                onChanged: (bool? value) {
                  onIngredientChecked(ingredient, value ?? false);
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
