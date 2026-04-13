import 'package:flutter/material.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';

void showFoodDeleteDialog(BuildContext context, AppLocalizations l10n, VoidCallback onDelete) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(l10n.deleteFood),
      content: Text(l10n.deleteConfirmation),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'), // Could be localized, but following existing code
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
            onDelete();
          },
          child: Text(l10n.deleteFood),
        ),
      ],
    ),
  );
}
