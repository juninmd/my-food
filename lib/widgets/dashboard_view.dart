import 'package:flutter/material.dart';
import 'package:my_food/data/diet_constants.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';
import 'package:my_food/models/meal.dart';
import 'package:my_food/widgets/macro_dashboard_card.dart';
import 'package:my_food/widgets/meal_timeline.dart';
import 'package:my_food/widgets/water_tracker.dart';

class DashboardView extends StatelessWidget {
  final Future<String> quoteFuture;
  final Meal breakfast;
  final Meal lunch;
  final Meal dinner;
  final int waterGlasses;
  final VoidCallback onAddWater;
  final Function(Meal) onEditBreakfast;
  final Function(Meal) onEditLunch;
  final Function(Meal) onEditDinner;
  final VoidCallback onSurpriseMe;

  const DashboardView({
    super.key,
    required this.quoteFuture,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.waterGlasses,
    required this.onAddWater,
    required this.onEditBreakfast,
    required this.onEditLunch,
    required this.onEditDinner,
    required this.onSurpriseMe,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    // Calculate totals
    int totalCalories = breakfast.calories + lunch.calories + dinner.calories;
    int totalProtein = breakfast.protein + lunch.protein + dinner.protein;
    int totalCarbs = breakfast.carbs + lunch.carbs + dinner.carbs;
    int totalFat = breakfast.fat + lunch.fat + dinner.fat;

    return ListView(
      padding: const EdgeInsets.only(bottom: 100),
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.hello,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.dashboardTitle,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              // Surprise Me Button
              FloatingActionButton.extended(
                heroTag: 'surprise_me_fab',
                onPressed: onSurpriseMe,
                icon: const Icon(Icons.auto_awesome),
                label: Text(l10n.surpriseMeButton),
                backgroundColor: colorScheme.secondary,
                foregroundColor: colorScheme.onSecondary,
                elevation: 2,
              ),
            ],
          ),
        ),

        // Quote
        FutureBuilder<String>(
          future: quoteFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colorScheme.primaryContainer),
                ),
                child: Row(
                  children: [
                    Icon(Icons.format_quote, color: colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        snapshot.data!,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),

        // Macro Dashboard
        MacroDashboardCard(
          calories: totalCalories,
          targetCalories: 2500, // Still static target
          protein: totalProtein,
          targetProtein: DietConstants.proteinTarget,
          carbs: totalCarbs,
          targetCarbs: DietConstants.carbsTarget,
          fat: totalFat,
          targetFat: DietConstants.fatTarget,
        ),

        // Water Tracker
        WaterTracker(
          currentGlasses: waterGlasses,
          targetGlasses: DietConstants.waterGlassTarget,
          onAdd: onAddWater,
        ),

        const SizedBox(height: 16),

        // Meal Timeline
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: [
              Icon(Icons.restaurant_menu, color: colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                l10n.dailyGoal,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        MealTimeline(
          breakfast: breakfast,
          lunch: lunch,
          dinner: dinner,
          onEditBreakfast: onEditBreakfast,
          onEditLunch: onEditLunch,
          onEditDinner: onEditDinner,
        ),
      ],
    );
  }
}
