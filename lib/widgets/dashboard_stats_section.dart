import 'package:flutter/material.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';
import 'package:my_food/data/diet_constants.dart';
import 'package:my_food/widgets/macro_dashboard_card.dart';
import 'package:my_food/widgets/nutritionist_note_card.dart';
import 'package:my_food/widgets/water_tracker.dart';
import 'package:my_food/widgets/dashboard_quote_section.dart';

class DashboardStatsSection extends StatelessWidget {
  final Future<String> quoteFuture;
  final int totalCalories;
  final int totalProtein;
  final int totalCarbs;
  final int totalFat;
  final int waterGlasses;
  final VoidCallback onAddWater;

  const DashboardStatsSection({
    super.key,
    required this.quoteFuture,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    required this.waterGlasses,
    required this.onAddWater,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth > 800;

                  final quoteWidget = DashboardQuoteSection(quoteFuture: quoteFuture);
                  const nutritionistNoteWidget = NutritionistNoteCard();

                  final topSection = isDesktop
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: quoteWidget),
                            const SizedBox(width: 16),
                            Expanded(child: nutritionistNoteWidget),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            quoteWidget,
                            nutritionistNoteWidget,
                          ],
                        );

                  final macroWidget = MacroDashboardCard(
                    calories: totalCalories,
                    targetCalories: DietConstants.caloriesTarget,
                    protein: totalProtein,
                    targetProtein: DietConstants.proteinTarget,
                    carbs: totalCarbs,
                    targetCarbs: DietConstants.carbsTarget,
                    fat: totalFat,
                    targetFat: DietConstants.fatTarget,
                  );

                  final waterWidget = WaterTracker(
                    currentGlasses: waterGlasses,
                    targetGlasses: DietConstants.waterGlassTarget,
                    onAdd: onAddWater,
                  );

                  final midSection = isDesktop
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: macroWidget),
                            const SizedBox(width: 16),
                            Expanded(child: waterWidget),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            macroWidget,
                            const SizedBox(height: 16),
                            waterWidget,
                          ],
                        );

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      topSection,
                      const SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          l10n.dailyGoal,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      midSection,
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
