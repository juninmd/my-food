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
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: colorScheme.secondary,
                  borderRadius: BorderRadius.circular(2),
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
      );

      listItems.add(
        Card(
          elevation: 4,
          shadowColor: Colors.black.withValues(alpha: 0.05),
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide.none,
          ),
          child: Column(
            children: ingredients.map((ingredient) {
              final count = ingredientCounts[ingredient];
              final isChecked = _checkedIngredients.contains(ingredient);
              final isLast = ingredient == ingredients.last;

              return Column(
                children: [
                  CheckboxListTile(
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
                        decoration:
                            isChecked ? TextDecoration.lineThrough : null,
                        color: isChecked
                            ? Colors.grey.withValues(alpha: 0.5)
                            : colorScheme.onSurface,
                        fontWeight:
                            isChecked ? FontWeight.w500 : FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    secondary: count! > 1
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'x$count',
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          )
                        : null,
                    activeColor: colorScheme.primary,
                    checkboxShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      thickness: 1,
                      indent: 56, // Align with text
                      endIndent: 20,
                      color: Colors.grey.shade100,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _copyToClipboard(ingredientCounts),
        icon: const Icon(Icons.copy_rounded),
        label: Text(l10n.shoppingListCopyTooltip),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            floating: true,
            pinned: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            surfaceTintColor: Colors.transparent,
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
