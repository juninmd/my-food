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

    final totalIngredients = ingredientCounts.length;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _copyToClipboard(ingredientCounts),
        icon: const Icon(Icons.copy),
        label: Text(l10n.shoppingListCopyTooltip),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.shoppingListTitle,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      if (_checkedIngredients.isNotEmpty)
                        IconButton.filledTonal(
                          onPressed: () {
                            setState(() {
                              _checkedIngredients.clear();
                              _saveCheckedIngredients();
                            });
                          },
                          icon: const Icon(Icons.delete_sweep_outlined),
                          style: IconButton.styleFrom(
                            backgroundColor: colorScheme.errorContainer,
                            foregroundColor: colorScheme.onErrorContainer,
                          ),
                          tooltip: "Clear Checked",
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: totalIngredients > 0
                                ? _checkedIngredients.length / totalIngredients
                                : 0,
                            minHeight: 8,
                            backgroundColor: Colors.grey.withValues(alpha: 0.1),
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "${_checkedIngredients.length}/$totalIngredients",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = listItems[index];

                  if (item is String && !ingredientCounts.containsKey(item)) {
                     // It's a Header (assuming category names don't clash with ingredients, which they shouldn't as ingredients are localized)
                     // A safer check is if item is in categories keys, but categorized keys are just strings.
                     // Since listItems is mixed, we can check categorized.containsKey(item).
                     if (categorized.containsKey(item)) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 16.0, bottom: 12.0),
                          child: Text(
                            item,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.secondary,
                            ),
                          ),
                        );
                     }
                  }

                  // It's an ingredient
                  final ingredient = item as String;
                  final count = ingredientCounts[ingredient];
                  final isChecked = _checkedIngredients.contains(ingredient);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isChecked ? Colors.transparent : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: isChecked
                             ? Border.all(color: Colors.grey.withValues(alpha: 0.2))
                             : Border.all(color: Colors.transparent),
                        boxShadow: isChecked ? [] : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          onTap: () {
                             setState(() {
                              if (isChecked) {
                                _checkedIngredients.remove(ingredient);
                              } else {
                                _checkedIngredients.add(ingredient);
                              }
                              _saveCheckedIngredients();
                            });
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            child: Row(
                              children: [
                                // Custom Checkbox (Circle) - Larger
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: isChecked ? colorScheme.primary : Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isChecked ? colorScheme.primary : Colors.grey.withValues(alpha: 0.4),
                                      width: 2,
                                    ),
                                  ),
                                  child: isChecked
                                      ? const Icon(Icons.check, size: 18, color: Colors.white)
                                      : null,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    ingredient,
                                    style: TextStyle(
                                      decoration: isChecked ? TextDecoration.lineThrough : null,
                                      color: isChecked ? Colors.grey.withValues(alpha: 0.5) : colorScheme.onSurface,
                                      fontWeight: isChecked ? FontWeight.w500 : FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                if (count! > 1)
                                  Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'x$count',
                                      style: TextStyle(
                                        color: colorScheme.onPrimaryContainer,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
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
