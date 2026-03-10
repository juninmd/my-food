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

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: CircularPercentIndicator(
              radius: 70.0,
              lineWidth: 16.0,
              percent: calorieProgress,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_fire_department_rounded,
                      size: 24, color: colorScheme.primary),
                  Text(
                    "$remaining",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 28,
                      color: colorScheme.onSurface,
                      letterSpacing: -1.0,
                      height: 1.0,
                    ),
                  ),
                  Text(
                    l10n.remaining.toLowerCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
              progressColor: colorScheme.primary,
              backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
              circularStrokeCap: CircularStrokeCap.round,
              animation: true,
              animationDuration: 1000,
              backgroundWidth: 12.0,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildMacroRow(context, l10n.macroProtein, protein,
                    targetProtein, colorScheme.secondary), // Dark Gray
                const SizedBox(height: 16),
                _buildMacroRow(context, l10n.macroCarbs, carbs, targetCarbs,
                    colorScheme.primary), // Mint Green
                const SizedBox(height: 16),
                _buildMacroRow(context, l10n.macroFat, fat, targetFat,
                    const Color(0xFF9E9E9E)), // Gray
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroRow(
      BuildContext context, String label, int value, int target, Color color) {
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
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              "${value}g / ${target}g",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearPercentIndicator(
          lineHeight: 6.0,
          percent: progress,
          progressColor: color,
          backgroundColor: color.withValues(alpha: 0.15),
          barRadius: const Radius.circular(3),
          padding: EdgeInsets.zero,
          animation: true,
          animationDuration: 1000,
        ),
      ],
    );
  }
}
