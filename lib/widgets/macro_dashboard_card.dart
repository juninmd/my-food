import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';

class MacroDashboardCard extends StatelessWidget {
  final int calories;
  final int targetCalories;
  final int protein;
  final int targetProtein;
  final int carbs;
  final int targetCarbs;
  final int fat;
  final int targetFat;

  const MacroDashboardCard({
    super.key,
    required this.calories,
    required this.targetCalories,
    required this.protein,
    required this.targetProtein,
    required this.carbs,
    required this.targetCarbs,
    required this.fat,
    required this.targetFat,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    int remaining = targetCalories - calories;
    if (remaining < 0) remaining = 0;
    double progress = targetCalories > 0 ? calories / targetCalories : 0;
    if (progress > 1.0) progress = 1.0;

    // No Card wrapper, just content for the parent container
    return Column(
      children: [
        // Calorie Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             Row(
               children: [
                 Icon(Icons.local_fire_department_rounded, size: 20, color: Colors.orange),
                 const SizedBox(width: 8),
                 Text(
                   l10n.caloriesTitle ?? "Calories", // Fallback if key missing, though it should be there or use macroCalories
                   style: TextStyle(
                     fontSize: 16,
                     fontWeight: FontWeight.bold,
                     color: colorScheme.onSurface,
                   ),
                 ),
               ],
             ),
             Text(
               "$calories / $targetCalories kcal",
               style: TextStyle(
                 fontSize: 14,
                 fontWeight: FontWeight.bold,
                 color: colorScheme.primary,
               ),
             ),
          ],
        ),
        const SizedBox(height: 20),

        // Content Row
        Row(
          children: [
            // Calorie Ring - Left
            CircularPercentIndicator(
              radius: 55.0,
              lineWidth: 10.0,
              percent: progress,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$remaining",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    l10n.remaining,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
              progressColor: colorScheme.primary,
              backgroundColor: colorScheme.surfaceContainerHighest,
              circularStrokeCap: CircularStrokeCap.round,
              animation: true,
              animationDuration: 1000,
            ),
            const SizedBox(width: 24),

            // Macros List - Right
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildMacroRow(context, l10n.macroProtein, protein, targetProtein, Colors.orange),
                  const SizedBox(height: 16),
                  _buildMacroRow(context, l10n.macroCarbs, carbs, targetCarbs, Colors.blue),
                  const SizedBox(height: 16),
                  _buildMacroRow(context, l10n.macroFat, fat, targetFat, Colors.purple),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMacroRow(BuildContext context, String label, int value, int target, Color color) {
    double progress = target > 0 ? value / target : 0;
    if (progress > 1.0) progress = 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(
                   color: Theme.of(context).colorScheme.onSurface,
                   fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
                ),
                children: [
                  TextSpan(
                    text: "$value",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  TextSpan(
                    text: "/${target}g",
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearPercentIndicator(
          lineHeight: 8.0,
          percent: progress,
          progressColor: color,
          backgroundColor: color.withValues(alpha: 0.1),
          barRadius: const Radius.circular(4),
          padding: EdgeInsets.zero,
          animation: true,
          animationDuration: 1000,
        ),
      ],
    );
  }
}
