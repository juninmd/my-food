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
    final colorScheme = Theme.of(context).colorScheme;

    int remaining = targetCalories - calories;
    if (remaining < 0) remaining = 0;

    // Donut chart data
    final double caloriesRatio = (calories / targetCalories).clamp(0.0, 1.0);
    final double remainingRatio = 1.0 - caloriesRatio;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.dailyGoal,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                // Calorie Donut
                SizedBox(
                  height: 140,
                  width: 140,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sectionsSpace: 0,
                          centerSpaceRadius: 50,
                          startDegreeOffset: 270,
                          sections: [
                            PieChartSectionData(
                              color: colorScheme.primary,
                              value: calories.toDouble(),
                              title: '',
                              radius: 16,
                              showTitle: false,
                            ),
                            PieChartSectionData(
                              color: colorScheme.surfaceContainerHighest ?? Colors.grey.shade100,
                              value: (targetCalories - calories).clamp(0, targetCalories).toDouble(),
                              title: '',
                              radius: 16,
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
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            l10n.remaining,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w600,
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
                      _buildMacroRow(context, l10n.macroProtein, protein, targetProtein, const Color(0xFFE57373)), // Soft Red
                      const SizedBox(height: 16),
                      _buildMacroRow(context, l10n.macroCarbs, carbs, targetCarbs, const Color(0xFFFFB74D)), // Soft Orange
                      const SizedBox(height: 16),
                      _buildMacroRow(context, l10n.macroFat, fat, targetFat, const Color(0xFFFFD54F)), // Soft Amber
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
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87)),
            Text.rich(
              TextSpan(
                text: "$value",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                children: [
                  TextSpan(
                    text: "/${target}g",
                    style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.normal, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withValues(alpha: 0.1),
            color: color,
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
