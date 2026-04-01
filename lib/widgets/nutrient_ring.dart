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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxWidth < 400;

          final ringWidget = CircularPercentIndicator(
            radius: isSmall ? 60.0 : 75.0,
            lineWidth: 10.0,
            percent: calorieProgress,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_fire_department_rounded,
                    size: 20, color: colorScheme.primary),
                const SizedBox(height: 4),
                Text(
                  "$remaining",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: isSmall ? 24 : 32,
                    color: colorScheme.onSurface,
                    letterSpacing: -1.0,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.remaining.toLowerCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
            progressColor: colorScheme.primary,
            backgroundColor: const Color(0xFFE6F9F5),
            circularStrokeCap: CircularStrokeCap.round,
            animation: true,
            animationDuration: 1000,
            backgroundWidth: 10.0,
          );

          final macrosWidget = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildMacroRow(context, l10n.macroProtein, protein, targetProtein,
                  colorScheme.secondary, Colors.grey.shade200),
              const SizedBox(height: 20),
              _buildMacroRow(context, l10n.macroCarbs, carbs, targetCarbs,
                  colorScheme.primary, const Color(0xFFE6F9F5)),
              const SizedBox(height: 20),
              _buildMacroRow(context, l10n.macroFat, fat, targetFat,
                  Colors.grey.shade400, Colors.grey.shade100),
            ],
          );

          if (isSmall) {
            return Column(
              children: [
                ringWidget,
                const SizedBox(height: 32),
                macrosWidget,
              ],
            );
          } else {
            return Row(
              children: [
                Expanded(flex: 5, child: ringWidget),
                const SizedBox(width: 32),
                Expanded(flex: 7, child: macrosWidget),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildMacroRow(
      BuildContext context, String label, int value, int target, Color color, Color bgColor) {
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
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              "${value}g / ${target}g",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
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
          backgroundColor: bgColor,
          barRadius: const Radius.circular(3),
          padding: EdgeInsets.zero,
          animation: true,
          animationDuration: 1000,
        ),
      ],
    );
  }
}
