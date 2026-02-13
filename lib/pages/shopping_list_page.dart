import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';

class ShoppingListPage extends StatefulWidget {
  final List<String> ingredients;

  const ShoppingListPage({super.key, required this.ingredients});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final Map<String, int> _ingredientCounts = {};
  final Set<String> _checkedIngredients = {};

  @override
  void initState() {
    super.initState();
    // Count occurrences of each ingredient
    for (var ingredient in widget.ingredients) {
      _ingredientCounts[ingredient] = (_ingredientCounts[ingredient] ?? 0) + 1;
    }
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sortedIngredients = _ingredientCounts.keys.toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.shoppingListTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: _copyToClipboard,
            tooltip: l10n.shoppingListCopyTooltip,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Total: ${sortedIngredients.length}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: sortedIngredients.length,
              itemBuilder: (context, index) {
                final ingredient = sortedIngredients[index];
                final count = _ingredientCounts[ingredient];
                final isChecked = _checkedIngredients.contains(ingredient);

                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: ListTile(
                    leading: Icon(
                      isChecked ? Icons.check_box : Icons.check_box_outline_blank,
                      color: isChecked ? Colors.green : Colors.grey,
                    ),
                    title: Text(
                      ingredient,
                      style: TextStyle(
                        decoration: isChecked ? TextDecoration.lineThrough : null,
                        color: isChecked ? Colors.grey : null,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: count! > 1
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'x$count',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          )
                        : null,
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
