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

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.caloriesTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              Icon(Icons.more_horiz, color: Colors.grey.shade400),
            ],
          ),
          const SizedBox(height: 24),

          // Main Indicator
          CircularPercentIndicator(
            radius: 80.0,
            lineWidth: 12.0,
            percent: progress,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_fire_department_rounded, size: 28, color: colorScheme.primary),
                const SizedBox(height: 4),
                Text(
                  "$remaining",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 32,
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
          const SizedBox(height: 32),

          // Macros Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMacroItem(context, l10n.macroProtein, protein, targetProtein, const Color(0xFFFF6D00)), // Orange
              Container(width: 1, height: 40, color: Colors.grey.shade100),
              _buildMacroItem(context, l10n.macroCarbs, carbs, targetCarbs, const Color(0xFF2196F3)), // Blue
              Container(width: 1, height: 40, color: Colors.grey.shade100),
              _buildMacroItem(context, l10n.macroFat, fat, targetFat, const Color(0xFF9C27B0)), // Purple
            ],
          ),
        ],
      ),
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
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "${value}g",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
