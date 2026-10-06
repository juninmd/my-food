import 'package:flutter/material.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/widgets/meal_detail_macro_item.dart';
import 'package:webdiet/models/meal.dart';

class MealDetailMacros extends StatelessWidget {
  final Meal meal;

  const MealDetailMacros({
    super.key,
    required this.meal,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildMealDetailMacroItem(
              context,
              l10n.caloriesTitle,
              "${meal.calories}",
              Icons.local_fire_department_rounded,
              Colors.orange.shade700,
              Colors.orange.shade50),
          buildMealDetailDivider(),
          buildMealDetailMacroItem(
              context,
              l10n.macroProtein,
              "${meal.protein}g",
              Icons.fitness_center_rounded,
              colorScheme.primary,
              colorScheme.primary.withValues(alpha: 0.1)),
          buildMealDetailDivider(),
          buildMealDetailMacroItem(
              context,
              l10n.macroCarbs,
              "${meal.carbs}g",
              Icons.bolt_rounded,
              Colors.blue.shade700,
              Colors.blue.shade50),
          buildMealDetailDivider(),
          buildMealDetailMacroItem(
              context,
              l10n.macroFat,
              "${meal.fat}g",
              Icons.water_drop_rounded,
              Colors.purple.shade700,
              Colors.purple.shade50),
        ],
      ),
    );
  }
}
