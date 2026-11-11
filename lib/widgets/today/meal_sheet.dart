import 'package:flutter/material.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/models/day_plan.dart';
import 'package:webdiet/models/meal.dart';
import 'package:webdiet/theme/app_tokens.dart';
import 'package:webdiet/theme/app_type.dart';
import 'package:webdiet/widgets/common/cascade_in.dart';
import 'package:webdiet/widgets/common/macro_tiles.dart';
import 'package:webdiet/widgets/common/meal_plate.dart';
import 'package:webdiet/widgets/today/day_line.dart';

/// Bottom sheet with everything about one meal: composition plate,
/// macros, ingredients, the nutritionist's note and the swap action.
class MealSheet extends StatelessWidget {
  final MealSlot slot;
  final Meal meal;
  final VoidCallback onSwap;

  const MealSheet({
    super.key,
    required this.slot,
    required this.meal,
    required this.onSwap,
  });

  static Future<void> show(BuildContext context,
      {required MealSlot slot,
      required Meal meal,
      required VoidCallback onSwap}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => MealSheet(slot: slot, meal: meal, onSwap: onSwap),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final l10n = AppLocalizations.of(context)!;

    return ConstrainedBox(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.88),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Center(
            child: MealPlate(
              protein: meal.protein,
              carbs: meal.carbs,
              fat: meal.fat,
              size: 120,
              spinIn: true,
            ),
          ),
          const SizedBox(height: 12),
          Text('${slot.time} · ${slotLabel(l10n, slot).toUpperCase()}',
              textAlign: TextAlign.center, style: AppType.label(t.ink2)),
          const SizedBox(height: 6),
          Text(meal.name,
              textAlign: TextAlign.center,
              style: AppType.display(26, color: t.ink)),
          const SizedBox(height: 6),
          Text(meal.description,
              textAlign: TextAlign.center, style: TextStyle(color: t.ink2)),
          const SizedBox(height: 18),
          MacroTiles(
            calories: meal.calories,
            protein: meal.protein,
            carbs: meal.carbs,
            fat: meal.fat,
          ),
          const SizedBox(height: 18),
          Text(l10n.ingredientsTitle.toUpperCase(),
              style: AppType.label(t.ink2)),
          const SizedBox(height: 8),
          Wrap(spacing: 6, runSpacing: 6, children: [
            for (var i = 0; i < meal.ingredients.length; i++)
              CascadeIn(
                index: i,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: t.sunk,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(meal.ingredients[i],
                      style: TextStyle(fontSize: 13, color: t.ink)),
                ),
              ),
          ]),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: t.mintSoft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.auto_awesome_rounded, size: 18, color: t.mint),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.nutritionistNoteTitle,
                          style: AppType.display(14, color: t.ink)),
                      const SizedBox(height: 2),
                      Text(l10n.nutritionistNoteBody,
                          style: TextStyle(fontSize: 13, color: t.ink)),
                    ]),
              ),
            ]),
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              onSwap();
            },
            icon: const Icon(Icons.swap_horiz_rounded),
            label: Text(l10n.swapMeal),
          ),
        ]),
      ),
    );
  }
}
