import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final now = DateTime.now();
    final dateFormat = DateFormat('EEE, d MMM', Localizations.localeOf(context).toString());

    // Calculate totals
    int totalCalories = breakfast.calories + lunch.calories + dinner.calories;
    int totalProtein = breakfast.protein + lunch.protein + dinner.protein;
    int totalCarbs = breakfast.carbs + lunch.carbs + dinner.carbs;
    int totalFat = breakfast.fat + lunch.fat + dinner.fat;

    return CustomScrollView(
      slivers: [
        // Header Sliver
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateFormat.format(now).toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.hello,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onSurface,
                        letterSpacing: -1.0,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      l10n.dashboardTitle,
                      style: TextStyle(
                        fontSize: 16,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                // User Avatar
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.2),
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                    child: Icon(
                      Icons.person_rounded,
                      color: colorScheme.primary,
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Quote Sliver
        SliverToBoxAdapter(
          child: FutureBuilder<String>(
            future: quoteFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.secondary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.format_quote_rounded, color: colorScheme.secondary, size: 20),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          snapshot.data!,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            height: 1.4,
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
        ),

        // Dashboard Content
        SliverList(
          delegate: SliverChildListDelegate([
            // Macro Card
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

            const SizedBox(height: 24),

            // Meal Timeline Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Text(
                l10n.menuTitle,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                  color: colorScheme.onSurface,
                ),
              ),
            ),

            // Meal Timeline
            MealTimeline(
              breakfast: breakfast,
              lunch: lunch,
              dinner: dinner,
              onEditBreakfast: onEditBreakfast,
              onEditLunch: onEditLunch,
              onEditDinner: onEditDinner,
            ),

            const SizedBox(height: 100), // Bottom padding
          ]),
        ),
      ],
    );
  }
}
