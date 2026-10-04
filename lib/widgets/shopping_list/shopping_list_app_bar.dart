import 'package:flutter/material.dart';

class ShoppingListAppBar extends StatelessWidget {
  final String title;
  final bool hasCheckedItems;
  final VoidCallback onClearChecked;

  const ShoppingListAppBar({
    super.key,
    required this.title,
    required this.hasCheckedItems,
    required this.onClearChecked,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SliverAppBar(
      expandedHeight: 120.0,
      floating: true,
      pinned: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
        title: Text(
          title,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: [
        if (hasCheckedItems)
          IconButton(
            onPressed: onClearChecked,
            icon: const Icon(Icons.delete_sweep_outlined),
            color: colorScheme.error,
            tooltip: "Clear Checked",
          ),
        const SizedBox(width: 16),
      ],
    );
  }
}
