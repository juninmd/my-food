import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
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

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.dailyGoal,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: colorScheme.onSurface,
                  ),
                ),
                Icon(
                  Icons.show_chart_rounded,
                  color: colorScheme.primary.withValues(alpha: 0.5),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Calorie Donut
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sectionsSpace: 0,
                          centerSpaceRadius: 60,
                          startDegreeOffset: 270,
                          sections: [
                            PieChartSectionData(
                              color: colorScheme.primary,
                              value: calories.toDouble(),
                              title: '',
                              radius: 12,
                              showTitle: false,
                            ),
                            PieChartSectionData(
                              color: colorScheme.surfaceContainerHighest ?? Colors.grey.shade100,
                              value: (targetCalories - calories).clamp(0, targetCalories).toDouble(),
                              title: '',
                              radius: 12,
                              showTitle: false,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$remaining",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 32,
                              color: colorScheme.onSurface,
                              height: 1.0,
                              letterSpacing: -1.0,
                            ),
                          ),
                          Text(
                            l10n.remaining, // "Remaining" or "kcal left"
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onSurface.withValues(alpha: 0.5),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                // Macros List
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildMacroRow(context, l10n.macroProtein, protein, targetProtein, const Color(0xFFFF8A65)), // Soft Orange/Red
                      const SizedBox(height: 20),
                      _buildMacroRow(context, l10n.macroCarbs, carbs, targetCarbs, const Color(0xFFFFD54F)), // Soft Amber
                      const SizedBox(height: 20),
                      _buildMacroRow(context, l10n.macroFat, fat, targetFat, const Color(0xFF4DB6AC)), // Soft Teal
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
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            RichText(
              text: TextSpan(
                text: "$value",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
                ),
                children: [
                  TextSpan(
                    text: "g",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                      fontWeight: FontWeight.normal,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 8,
          width: double.infinity,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(4),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: 8,
                    width: constraints.maxWidth * progress,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
