import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';

class ShoppingListView extends StatefulWidget {
  final List<String> ingredients;

  const ShoppingListView({super.key, required this.ingredients});

  @override
  State<ShoppingListView> createState() => _ShoppingListViewState();
}

class _ShoppingListViewState extends State<ShoppingListView> {
  final Map<String, int> _ingredientCounts = {};
  final Set<String> _checkedIngredients = {};

  @override
  void initState() {
    super.initState();
    _updateCounts();
    _loadCheckedIngredients();
  }

  @override
  void didUpdateWidget(ShoppingListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.ingredients != oldWidget.ingredients) {
       _updateCounts();
    }
  }

  void _updateCounts() {
    _ingredientCounts.clear();
    for (var ingredient in widget.ingredients) {
      _ingredientCounts[ingredient] = (_ingredientCounts[ingredient] ?? 0) + 1;
    }
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

  void _copyToClipboard() {
    final l10n = AppLocalizations.of(context)!;
    final buffer = StringBuffer();
    buffer.writeln(l10n.shoppingListClipboardTitle);

    final sortedIngredients = _ingredientCounts.keys.toList()..sort();

    for (var ingredient in sortedIngredients) {
      final count = _ingredientCounts[ingredient];
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sortedIngredients = _ingredientCounts.keys.toList()..sort();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _copyToClipboard,
        icon: const Icon(Icons.copy),
        label: Text(l10n.shoppingListCopyTooltip), // Or "Share"
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.shoppingListTitle,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                // Keeping header clean, FAB handles action
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80), // Space for FAB
              itemCount: sortedIngredients.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final ingredient = sortedIngredients[index];
                final count = _ingredientCounts[ingredient];
                final isChecked = _checkedIngredients.contains(ingredient);

                return Material(
                  color: Colors.transparent,
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
                        color: isChecked ? Colors.grey : colorScheme.onSurface,
                        fontWeight: isChecked ? FontWeight.normal : FontWeight.w500,
                      ),
                    ),
                    secondary: count! > 1
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(20),
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
                    checkColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isChecked ? Colors.transparent : Colors.grey.shade300,
                      ),
                    ),
                    tileColor: isChecked ? Colors.grey.shade50 : Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
