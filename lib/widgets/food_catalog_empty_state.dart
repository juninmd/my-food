import 'package:flutter/material.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/theme/app_tokens.dart';
import 'package:webdiet/widgets/common/meal_plate.dart';

/// Empty catalog or no search results: a faded plate, the reason and a
/// shortcut to add a food.
class FoodCatalogEmptyState extends StatelessWidget {
  final String message;
  final VoidCallback onAdd;

  const FoodCatalogEmptyState({
    super.key,
    required this.message,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(children: [
        const Opacity(
          opacity: 0.5,
          child: MealPlate(protein: 10, carbs: 10, fat: 5, size: 88),
        ),
        const SizedBox(height: 16),
        Text(message,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700, color: t.ink)),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add_rounded),
          label: Text(l10n.addFoodTitle),
        ),
      ]),
    );
  }
}
