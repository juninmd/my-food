import 'package:flutter/material.dart';
import 'package:webdiet/theme/app_tokens.dart';
import 'package:webdiet/theme/app_type.dart';
import 'package:webdiet/widgets/common/cascade_in.dart';
import 'package:webdiet/widgets/shopping_list/shopping_list_item_tile.dart';

/// One aisle of the list. Items already in the cart sink to the bottom.
class ShoppingListCategory extends StatelessWidget {
  final int index;
  final String category;
  final List<String> ingredients;
  final Map<String, int> ingredientCounts;
  final Set<String> checkedIngredients;
  final void Function(String ingredient, bool checked) onIngredientChecked;

  const ShoppingListCategory({
    super.key,
    this.index = 0,
    required this.category,
    required this.ingredients,
    required this.ingredientCounts,
    required this.checkedIngredients,
    required this.onIngredientChecked,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final ordered = [
      ...ingredients.where((i) => !checkedIngredients.contains(i)),
      ...ingredients.where(checkedIngredients.contains),
    ];

    return CascadeIn(
      index: index,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
        decoration: t.card(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(category.toUpperCase(), style: AppType.label(t.ink2)),
          const SizedBox(height: 4),
          for (final ingredient in ordered)
            ShoppingListItemTile(
              key: ValueKey(ingredient),
              ingredient: ingredient,
              count: ingredientCounts[ingredient] ?? 1,
              isChecked: checkedIngredients.contains(ingredient),
              isLast: ingredient == ordered.last,
              onChanged: (v) => onIngredientChecked(ingredient, v ?? false),
            ),
        ]),
      ),
    );
  }
}
