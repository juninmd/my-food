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
      color: colorScheme.primary,
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
                    color: colorScheme.onPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                       Icon(Icons.bolt, size: 16, color: colorScheme.onPrimary),
                       const SizedBox(width: 4),
                       Text(
                        "$calories / $targetCalories",
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Calorie Ring
            SizedBox(
              height: 180,
              width: 180,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 0,
                      centerSpaceRadius: 75,
                      startDegreeOffset: 270,
                      sections: [
                        PieChartSectionData(
                          color: Colors.white,
                          value: calories.toDouble(),
                          title: '',
                          radius: 12,
                          showTitle: false,
                        ),
                        PieChartSectionData(
                          color: Colors.white.withValues(alpha: 0.2),
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
                          fontSize: 42,
                          color: colorScheme.onPrimary,
                          height: 1.0,
                          letterSpacing: -2.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.remaining.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          color: colorScheme.onPrimary.withValues(alpha: 0.8),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
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
                    Icons.fitness_center,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                Expanded(
                  child: _buildMacroColumn(
                    context,
                    l10n.macroCarbs,
                    carbs,
                    targetCarbs,
                    Icons.grain,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                Expanded(
                  child: _buildMacroColumn(
                    context,
                    l10n.macroFat,
                    fat,
                    targetFat,
                    Icons.water_drop,
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
      BuildContext context, String label, int value, int target, IconData icon) {
    double progress = target > 0 ? value / target : 0;
    if (progress > 1.0) progress = 1.0;

    final onPrimary = Theme.of(context).colorScheme.onPrimary;

    return Column(
      children: [
        Icon(icon, color: onPrimary.withValues(alpha: 0.8), size: 20),
        const SizedBox(height: 8),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 10,
            color: onPrimary.withValues(alpha: 0.7),
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "${value}g",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: onPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              color: Colors.white,
              minHeight: 4,
            ),
          ),
        ),
      ],
    );
  }
}
