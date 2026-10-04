import 'package:flutter/material.dart';

class ShoppingListItemTile extends StatelessWidget {
  final String ingredient;
  final int count;
  final bool isChecked;
  final bool isLast;
  final ValueChanged<bool?> onChanged;

  const ShoppingListItemTile({
    super.key,
    required this.ingredient,
    required this.count,
    required this.isChecked,
    required this.isLast,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        CheckboxListTile(
          value: isChecked,
          onChanged: onChanged,
          title: Text(
            ingredient,
            style: TextStyle(
              decoration: isChecked ? TextDecoration.lineThrough : null,
              color: isChecked
                  ? Colors.grey.withValues(alpha: 0.5)
                  : colorScheme.onSurface,
              fontWeight: isChecked ? FontWeight.w500 : FontWeight.w600,
              fontSize: 15,
            ),
          ),
          secondary: count > 1
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(24),
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
            borderRadius: BorderRadius.circular(24),
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
  }
}
