import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/utils/ingredient_categorizer.dart';
import 'package:webdiet/widgets/shopping_list/shopping_list_category.dart';
import 'package:webdiet/widgets/shopping_list/shopping_list_app_bar.dart';
import 'package:webdiet/widgets/shopping_list/shopping_list_clipboard.dart';

class ShoppingListView extends StatefulWidget {
  final List<String> ingredients;

  const ShoppingListView({super.key, required this.ingredients});

  @override
  State<ShoppingListView> createState() => _ShoppingListViewState();
}

class _ShoppingListViewState extends State<ShoppingListView> {
  final Set<String> _checkedIngredients = {};

  @override
  void initState() {
    super.initState();
    _loadCheckedIngredients();
  }

  Future<void> _loadCheckedIngredients() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    final List<String>? checked = prefs.getStringList('checked_ingredients');
    if (checked != null) {
      setState(() {
        _checkedIngredients.addAll(checked);
      });
    }
  }

  Future<void> _saveCheckedIngredients() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'checked_ingredients', _checkedIngredients.toList());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    // 1. Calculate Counts
    final Map<String, int> ingredientCounts = {};
    for (var ingredient in widget.ingredients) {
      ingredientCounts[ingredient] = (ingredientCounts[ingredient] ?? 0) + 1;
    }

    // 2. Categorize
    final Map<String, List<String>> categorized = {};
    for (var ingredient in ingredientCounts.keys) {
      final category = IngredientCategorizer.getCategory(ingredient, l10n);
      categorized.putIfAbsent(category, () => []).add(ingredient);
    }

    // 3. Build List of Widgets
    final List<Widget> listItems = [];
    final sortedCategories = categorized.keys.toList()..sort();

    // Ensure "Other" is last if present
    if (sortedCategories.contains(l10n.catOther)) {
      sortedCategories.remove(l10n.catOther);
      sortedCategories.add(l10n.catOther);
    }

    for (var category in sortedCategories) {
      final ingredients = categorized[category]!;
      ingredients.sort();

      listItems.add(
        ShoppingListCategory(
          category: category,
          ingredients: ingredients,
          ingredientCounts: ingredientCounts,
          checkedIngredients: _checkedIngredients,
          onIngredientChecked: (ingredient, isChecked) {
            setState(() {
              if (isChecked) {
                _checkedIngredients.add(ingredient);
              } else {
                _checkedIngredients.remove(ingredient);
              }
              _saveCheckedIngredients();
            });
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => copyShoppingListToClipboard(
            context, l10n, ingredientCounts, _checkedIngredients),
        icon: const Icon(Icons.copy_rounded),
        label: Text(l10n.shoppingListCopyTooltip),
      ),
      body: CustomScrollView(
        slivers: [
          ShoppingListAppBar(
            title: l10n.shoppingListTitle,
            hasCheckedItems: _checkedIngredients.isNotEmpty,
            onClearChecked: () {
              setState(() {
                _checkedIngredients.clear();
                _saveCheckedIngredients();
              });
            },
          ),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => listItems[index],
                childCount: listItems.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
