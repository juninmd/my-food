import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';
import 'package:my_food/utils/ingredient_categorizer.dart';

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

  void _copyToClipboard(Map<String, int> ingredientCounts) {
    final l10n = AppLocalizations.of(context)!;
    final buffer = StringBuffer();
    buffer.writeln(l10n.shoppingListClipboardTitle);

    final sortedIngredients = ingredientCounts.keys.toList()..sort();

    for (var ingredient in sortedIngredients) {
      final count = ingredientCounts[ingredient];
      final isChecked = _checkedIngredients.contains(ingredient);
      final checkStatus = isChecked ? '[x]' : '[ ]';
      final quantity = count! > 1 ? ' (x$count)' : '';

      buffer.writeln('$checkStatus $ingredient$quantity');
    }

    Clipboard.setData(ClipboardData(text: buffer.toString()));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.shoppingListCopied),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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

    // 3. Flatten List
    final List<dynamic> listItems = [];
    final sortedCategories = categorized.keys.toList()..sort();

    // Ensure "Other" is last if present (optional polish)
    if (sortedCategories.contains("Other")) {
      sortedCategories.remove("Other");
      sortedCategories.add("Other");
    }

    for (var category in sortedCategories) {
      listItems.add(category); // Add Header
      final ingredients = categorized[category]!;
      ingredients.sort();
      listItems.addAll(ingredients); // Add Ingredients
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _copyToClipboard(ingredientCounts),
        icon: const Icon(Icons.copy),
        label: Text(l10n.shoppingListCopyTooltip),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            floating: true,
            pinned: true,
            backgroundColor: colorScheme.surface,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
              title: Text(
                l10n.shoppingListTitle,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            actions: [
              if (_checkedIngredients.isNotEmpty)
                IconButton(
                  onPressed: () {
                    setState(() {
                      _checkedIngredients.clear();
                      _saveCheckedIngredients();
                    });
                  },
                  icon: const Icon(Icons.delete_sweep_outlined),
                  color: colorScheme.error,
                  tooltip: "Clear Checked",
                ),
              const SizedBox(width: 16),
            ],
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = listItems[index];

                  if (item is String && !ingredientCounts.containsKey(item)) {
                     // It's a Header
                     if (categorized.containsKey(item)) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
                          child: Text(
                            item.toUpperCase(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                              letterSpacing: 1.2,
                            ),
                          ),
                        );
                     }
                  }

                  // It's an ingredient
                  final ingredient = item as String;
                  final count = ingredientCounts[ingredient];
                  final isChecked = _checkedIngredients.contains(ingredient);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CheckboxListTile(
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _checkedIngredients.add(ingredient);
                          } else {
                            _checkedIngredients.remove(ingredient);
                          }
                          _saveCheckedIngredients();
                        });
                      },
                      title: Text(
                        ingredient,
                        style: TextStyle(
                          decoration: isChecked ? TextDecoration.lineThrough : null,
                          color: isChecked ? Colors.grey.withValues(alpha: 0.5) : colorScheme.onSurface,
                          fontWeight: isChecked ? FontWeight.w500 : FontWeight.w600,
                        ),
                      ),
                      secondary: count! > 1
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'x$count',
                                style: TextStyle(
                                  color: colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          : null,
                      activeColor: colorScheme.primary,
                      checkboxShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
                childCount: listItems.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
