import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';

void copyShoppingListToClipboard(
  BuildContext context,
  AppLocalizations l10n,
  Map<String, int> ingredientCounts,
  Set<String> checkedIngredients,
) {
  final buffer = StringBuffer();
  buffer.writeln(l10n.shoppingListClipboardTitle);

  final sortedIngredients = ingredientCounts.keys.toList()..sort();

  for (var ingredient in sortedIngredients) {
    final count = ingredientCounts[ingredient];
    final isChecked = checkedIngredients.contains(ingredient);
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
