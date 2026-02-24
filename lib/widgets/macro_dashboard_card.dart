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

    return Column(
      children: [
        // Ring Centered
        Stack(
          alignment: Alignment.center,
          children: [
            CircularPercentIndicator(
              radius: 70.0,
              lineWidth: 12.0,
              percent: progress,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.local_fire_department_rounded, size: 24, color: Colors.orange),
                  const SizedBox(height: 4),
                  Text(
                    "$remaining",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 28,
                      color: colorScheme.onSurface,
                      letterSpacing: -1.0,
                    ),
                  ),
                  Text(
                    l10n.remaining.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      color: Colors.grey.shade500,
                      letterSpacing: 1.0,
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
          ],
        ),
        const SizedBox(height: 32),

        // Macros Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildMacroItem(context, l10n.macroProtein, protein, targetProtein, Colors.orange),
            Container(width: 1, height: 40, color: Colors.grey.shade200),
            _buildMacroItem(context, l10n.macroCarbs, carbs, targetCarbs, Colors.blue),
             Container(width: 1, height: 40, color: Colors.grey.shade200),
            _buildMacroItem(context, l10n.macroFat, fat, targetFat, Colors.purple),
          ],
        ),
      ],
    );
  }

  Widget _buildMacroItem(BuildContext context, String label, int value, int target, Color color) {
    double progress = target > 0 ? value / target : 0;
    if (progress > 1.0) progress = 1.0;

    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "${value}g",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: LinearPercentIndicator(
              lineHeight: 6.0,
              percent: progress,
              progressColor: color,
              backgroundColor: color.withValues(alpha: 0.1),
              barRadius: const Radius.circular(3),
              padding: EdgeInsets.zero,
              animation: true,
              animationDuration: 1000,
            ),
          ),
        ],
      ),
    );
  }
}
