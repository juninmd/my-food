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

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            // Calorie Ring
            Expanded(
              flex: 5,
              child: AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
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
                            color: colorScheme.surfaceContainerHighest ?? Colors.grey.shade200,
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
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          l10n.remaining, // "Remaining" or "Restantes"
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 24),
            // Macros
            Expanded(
              flex: 6,
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
            Text.rich(
              TextSpan(
                text: "$value",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                children: [
                  TextSpan(
                    text: "/${target}g",
                    style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withValues(alpha: 0.15),
            color: color,
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
