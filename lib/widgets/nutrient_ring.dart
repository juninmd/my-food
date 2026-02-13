import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';

class NutrientRing extends StatelessWidget {
  final int calories;
  final int targetCalories;
  final int protein;
  final int targetProtein;
  final int carbs;
  final int targetCarbs;
  final int fat;
  final int targetFat;

  const NutrientRing({
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
    final colorScheme = Theme.of(context).colorScheme;

    double calorieProgress = targetCalories > 0 ? calories / targetCalories : 0;
    if (calorieProgress > 1.0) calorieProgress = 1.0;

    int remaining = targetCalories - calories;
    if (remaining < 0) remaining = 0;

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: CircularPercentIndicator(
                    radius: 60.0,
                    lineWidth: 12.0,
                    percent: calorieProgress,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "$remaining",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        Text(
                          l10n.remaining,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    progressColor: colorScheme.primary,
                    backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                    circularStrokeCap: CircularStrokeCap.round,
                    animation: true,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildMacroRow(context, l10n.macroProtein, protein, targetProtein, Colors.redAccent),
                      const SizedBox(height: 12),
                      _buildMacroRow(context, l10n.macroCarbs, carbs, targetCarbs, Colors.orangeAccent),
                      const SizedBox(height: 12),
                      _buildMacroRow(context, l10n.macroFat, fat, targetFat, Colors.amber),
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
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
            Text("${value}g / ${target}g", style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
          ],
        ),
        const SizedBox(height: 4),
        LinearPercentIndicator(
          lineHeight: 8.0,
          percent: progress,
          progressColor: color,
          backgroundColor: color.withValues(alpha: 0.1),
          barRadius: const Radius.circular(4),
          padding: EdgeInsets.zero,
          animation: true,
        ),
      ],
    );
  }
}
