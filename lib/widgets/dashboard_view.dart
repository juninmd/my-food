import 'package:flutter/material.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';
import 'package:my_food/models/meal.dart';
import 'package:my_food/widgets/dashboard_header.dart';
import 'package:my_food/widgets/dashboard_stats_section.dart';
import 'package:my_food/widgets/dashboard_surprise_button.dart';
import 'package:my_food/widgets/meal_timeline.dart';

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

    // Calculate totals
    int totalCalories = breakfast.calories + lunch.calories + dinner.calories;
    int totalProtein = breakfast.protein + lunch.protein + dinner.protein;
    int totalCarbs = breakfast.carbs + lunch.carbs + dinner.carbs;
    int totalFat = breakfast.fat + lunch.fat + dinner.fat;

    return CustomScrollView(
      slivers: [
        const DashboardHeader(),
        SliverToBoxAdapter(
          child: DashboardStatsSection(
            quoteFuture: quoteFuture,
            totalCalories: totalCalories,
            totalProtein: totalProtein,
            totalCarbs: totalCarbs,
            totalFat: totalFat,
            waterGlasses: waterGlasses,
            onAddWater: onAddWater,
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(top: 16)),
        SliverToBoxAdapter(
          child: DashboardSurpriseButton(onSurpriseMe: onSurpriseMe),
        ),
        const SliverPadding(padding: EdgeInsets.only(top: 32)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(Icons.restaurant_menu_rounded,
                      color: colorScheme.primary, size: 22),
                ),
                const SizedBox(width: 16),
                Text(
                  l10n.menuTitle,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(top: 16, bottom: 100),
          sliver: SliverToBoxAdapter(
            child: MealTimeline(
              breakfast: breakfast,
              lunch: lunch,
              dinner: dinner,
              onEditBreakfast: onEditBreakfast,
              onEditLunch: onEditLunch,
              onEditDinner: onEditDinner,
            ),
          ),
        ),
      ],
    );
  }
}
