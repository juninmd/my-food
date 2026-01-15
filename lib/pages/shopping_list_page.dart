import 'package:flutter/material.dart';

class ShoppingListPage extends StatelessWidget {
  final List<String> ingredients;

  const ShoppingListPage({Key? key, required this.ingredients}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Count occurrences of each ingredient
    final Map<String, int> ingredientCounts = {};
    for (var ingredient in ingredients) {
      ingredientCounts[ingredient] = (ingredientCounts[ingredient] ?? 0) + 1;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Compras'),
      ),
      body: ListView.builder(
        itemCount: ingredientCounts.length,
        itemBuilder: (context, index) {
          final ingredient = ingredientCounts.keys.elementAt(index);
          final count = ingredientCounts[ingredient];
          return ListTile(
            leading: const Icon(Icons.check_box_outline_blank),
            title: Text(ingredient),
            trailing: count! > 1 ? Text('x$count') : null,
          );
        },
      ),
    );
  }
}
