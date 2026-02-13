import 'package:flutter/material.dart';
import 'package:my_food/data/diet_constants.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';
import 'package:my_food/models/meal.dart';
import 'package:my_food/widgets/meal_timeline.dart';
import 'package:my_food/widgets/nutrient_ring.dart';
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
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Calculate totals
    int totalCalories = breakfast.calories + lunch.calories + dinner.calories;
    int totalProtein = breakfast.protein + lunch.protein + dinner.protein;
    int totalCarbs = breakfast.carbs + lunch.carbs + dinner.carbs;
    int totalFat = breakfast.fat + lunch.fat + dinner.fat;

    return ListView(
      padding: const EdgeInsets.only(bottom: 100), // Space for FAB/BottomNav if needed
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          child: Column(
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
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // Quote
        FutureBuilder<String>(
          future: quoteFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Text(
                  snapshot.data!,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Text(
                  l10n.quoteFallbackMessage,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),

        // Nutrient Ring
        NutrientRing(
          calories: totalCalories,
          targetCalories: 2500, // Assuming static target for now as per original code
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
          child: Text(
            l10n.dailyGoal, // Or maybe "Today's Meals"
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
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
