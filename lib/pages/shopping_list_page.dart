import 'package:flutter/material.dart';
import '../data/diet_data.dart';

class ShoppingListPage extends StatelessWidget {
  final DietData dietData;

  const ShoppingListPage({Key? key, required this.dietData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: dietData,
      builder: (context, child) {
        final shoppingList = dietData.shoppingList;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Lista de Compras'),
            backgroundColor: Colors.black,
          ),
          body: shoppingList.isEmpty
              ? const Center(child: Text('Nenhum item na lista'))
              : ListView.separated(
                  itemCount: shoppingList.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final ingredient = shoppingList.keys.elementAt(index);
                    final quantity = shoppingList[ingredient];
                    return ListTile(
                      leading: Icon(Icons.check_circle_outline, color: Colors.green),
                      title: Text(ingredient),
                      trailing: Text(
                        'x$quantity',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
