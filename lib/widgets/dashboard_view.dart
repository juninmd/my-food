import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_food/data/diet_constants.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';
import 'package:my_food/models/meal.dart';
import 'package:my_food/widgets/macro_dashboard_card.dart';
import 'package:my_food/widgets/meal_timeline.dart';
import 'package:my_food/widgets/nutritionist_note_card.dart';
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
    final dateFormat = DateFormat('EEEE, d MMM', Localizations.localeOf(context).toString());

    // Calculate totals
    int totalCalories = breakfast.calories + lunch.calories + dinner.calories;
    int totalProtein = breakfast.protein + lunch.protein + dinner.protein;
    int totalCarbs = breakfast.carbs + lunch.carbs + dinner.carbs;
    int totalFat = breakfast.fat + lunch.fat + dinner.fat;

    return CustomScrollView(
      slivers: [
        // Modern App Bar Header
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
          sliver: SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            l10n.hello,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: colorScheme.onSurface,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Plan Status Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green.shade100),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.check_circle, size: 12, color: Colors.green.shade700),
                                const SizedBox(width: 4),
                                Text(
                                  l10n.planStatus, // "Active" or similar
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.approvedBy, // "Approved by Dr. Smith"
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                // Actions
                Row(
                  children: [
                    IconButton(
                      onPressed: onSurpriseMe,
                      icon: const Icon(Icons.auto_awesome),
                      tooltip: l10n.surpriseMeButton,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.purple.shade50,
                        foregroundColor: Colors.purple,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.2),
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                        child: Icon(Icons.person, size: 20, color: colorScheme.primary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Nutritionist Note
        const SliverToBoxAdapter(
          child: NutritionistNoteCard(),
        ),

        // Daily Summary Section
        SliverToBoxAdapter(
          child: Column(
            children: [
              MacroDashboardCard(
                calories: totalCalories,
                targetCalories: 2500,
                protein: totalProtein,
                targetProtein: DietConstants.proteinTarget,
                carbs: totalCarbs,
                targetCarbs: DietConstants.carbsTarget,
                fat: totalFat,
                targetFat: DietConstants.fatTarget,
              ),
              WaterTracker(
                currentGlasses: waterGlasses,
                targetGlasses: DietConstants.waterGlassTarget,
                onAdd: onAddWater,
              ),
            ],
          ),
        ),

        // Quote (Moved below trackers for cleaner top flow)
        SliverToBoxAdapter(
          child: FutureBuilder<String>(
            future: quoteFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  margin: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade100),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.format_quote_rounded, color: colorScheme.primary.withValues(alpha: 0.4), size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          snapshot.data!,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
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

        // Meal Timeline Header
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          sliver: SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 18, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      l10n.menuTitle,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                Text(
                  dateFormat.format(now).toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface.withValues(alpha: 0.4),
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Meal Timeline
        SliverToBoxAdapter(
          child: MealTimeline(
            breakfast: breakfast,
            lunch: lunch,
            dinner: dinner,
            onEditBreakfast: onEditBreakfast,
            onEditLunch: onEditLunch,
            onEditDinner: onEditDinner,
          ),
        ),

        const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
      ],
    );
  }
}
