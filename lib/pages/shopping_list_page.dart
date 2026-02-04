import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    await prefs.setStringList('checked_ingredients', _checkedIngredients.toList());
  }

  void _copyToClipboard() {
    final buffer = StringBuffer();
    buffer.writeln('Lista de Compras:');

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
      const SnackBar(
        content: Text('Lista copiada para a área de transferência!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sortedIngredients = _ingredientCounts.keys.toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Compras'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: _copyToClipboard,
            tooltip: 'Copiar lista',
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: sortedIngredients.length,
        itemBuilder: (context, index) {
          final ingredient = sortedIngredients[index];
          final count = _ingredientCounts[ingredient];
          final isChecked = _checkedIngredients.contains(ingredient);

          return ListTile(
            leading: Icon(
              isChecked ? Icons.check_box : Icons.check_box_outline_blank,
              color: isChecked ? Colors.green : null,
            ),
            title: Text(
              ingredient,
              style: TextStyle(
                decoration: isChecked ? TextDecoration.lineThrough : null,
                color: isChecked ? Colors.grey : null,
              ),
            ),
            trailing: count! > 1 ? Text('x$count') : null,
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
          );
        },
      ),
    );
  }
}
