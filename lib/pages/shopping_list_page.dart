import 'package:flutter/material.dart';

class ShoppingListPage extends StatefulWidget {
  final List<String> ingredients;

  const ShoppingListPage({Key? key, required this.ingredients}) : super(key: key);

  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
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
  }

  @override
  Widget build(BuildContext context) {
    final sortedIngredients = _ingredientCounts.keys.toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Compras'),
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
              });
            },
          );
        },
      ),
    );
  }
}
