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

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      // Theme handles elevation and shape
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.yourProgress,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "$calories / $targetCalories kcal",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
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
                  radius: 50.0, // Smaller than before
                  lineWidth: 8.0,
                  percent: progress,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$remaining",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 20, // Smaller font
                          color: colorScheme.primary,
                        ),
                      ),
                      Text(
                        l10n.remaining,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
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
                      const SizedBox(height: 12),
                      _buildMacroRow(context, l10n.macroCarbs, carbs, targetCarbs, Colors.blue),
                      const SizedBox(height: 12),
                      _buildMacroRow(context, l10n.macroFat, fat, targetFat, Colors.purple),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
            Text(
              "${value}g", // Simplified text
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearPercentIndicator(
          lineHeight: 6.0, // Thinner bar
          percent: progress,
          progressColor: color,
          backgroundColor: color.withValues(alpha: 0.1),
          barRadius: const Radius.circular(3),
          padding: EdgeInsets.zero,
          animation: true,
          animationDuration: 1000,
        ),
      ],
    );
  }
}
