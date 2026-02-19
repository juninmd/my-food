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
      // CardTheme handles shape, color, and border
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "$calories / $targetCalories kcal",
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Calorie Ring
            SizedBox(
              height: 160,
              width: 160,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 0,
                      centerSpaceRadius: 65,
                      startDegreeOffset: 270,
                      sections: [
                        PieChartSectionData(
                          color: colorScheme.primary,
                          value: calories.toDouble(),
                          title: '',
                          radius: 15,
                          showTitle: false,
                        ),
                        PieChartSectionData(
                          color: colorScheme.surfaceContainerHighest ?? const Color(0xFFF0F0F0),
                          value: (targetCalories - calories).clamp(0, targetCalories).toDouble(),
                          title: '',
                          radius: 15,
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
                          fontSize: 36,
                          color: colorScheme.onSurface,
                          height: 1.0,
                          letterSpacing: -1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.remaining,
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
            const SizedBox(height: 40),
            // Macros Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _buildMacroColumn(
                    context,
                    l10n.macroProtein,
                    protein,
                    targetProtein,
                    const Color(0xFFFF8A65), // Soft Orange
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey.withValues(alpha: 0.1),
                ),
                Expanded(
                  child: _buildMacroColumn(
                    context,
                    l10n.macroCarbs,
                    carbs,
                    targetCarbs,
                    const Color(0xFFFFD54F), // Soft Amber
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey.withValues(alpha: 0.1),
                ),
                Expanded(
                  child: _buildMacroColumn(
                    context,
                    l10n.macroFat,
                    fat,
                    targetFat,
                    const Color(0xFF4DB6AC), // Soft Teal
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroColumn(
      BuildContext context, String label, int value, int target, Color color) {
    double progress = target > 0 ? value / target : 0;
    if (progress > 1.0) progress = 1.0;

    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "${value}g",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withValues(alpha: 0.15),
              color: color,
              minHeight: 6,
            ),
          ),
        ),
      ],
    );
  }
}
