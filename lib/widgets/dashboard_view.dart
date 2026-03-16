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
    final dateFormat =
        DateFormat('EEEE, d MMMM', Localizations.localeOf(context).toString());

    // Calculate totals
    int totalCalories = breakfast.calories + lunch.calories + dinner.calories;
    int totalProtein = breakfast.protein + lunch.protein + dinner.protein;
    int totalCarbs = breakfast.carbs + lunch.carbs + dinner.carbs;
    int totalFat = breakfast.fat + lunch.fat + dinner.fat;

    return CustomScrollView(
      slivers: [
        // App Bar & Header
        SliverAppBar(
          expandedHeight: 140.0,
          floating: false,
          pinned: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: false,
            titlePadding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            title: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.hello,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.waving_hand, color: Colors.amber, size: 24),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateFormat.format(now),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 24.0, top: 8),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: colorScheme.primary.withOpacity(0.1),
                  child: Icon(Icons.person, color: colorScheme.primary),
                ),
              ),
            ),
          ],
        ),

        // Quote
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: FutureBuilder<String>(
              future: quoteFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData || snapshot.hasError) {
                  final text = snapshot.hasError
                      ? l10n.quoteFallbackMessage
                      : snapshot.data!;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: Colors.transparent),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.format_quote_rounded,
                            color: colorScheme.secondary, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            text,
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: colorScheme.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
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
        ),

        // Nutritionist Note
        const SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: const NutritionistNoteCard(),
          ),
        ),


        // Daily Goal Title
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              l10n.dailyGoal,
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

        // Daily Progress (Macros)
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          sliver: SliverToBoxAdapter(
            child: MacroDashboardCard(
              calories: totalCalories,
              targetCalories: DietConstants.caloriesTarget,
              protein: totalProtein,
              targetProtein: DietConstants.proteinTarget,
              carbs: totalCarbs,
              targetCarbs: DietConstants.carbsTarget,
              fat: totalFat,
              targetFat: DietConstants.fatTarget,
            ),
          ),
        ),

        // Water Tracker
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          sliver: SliverToBoxAdapter(
            child: WaterTracker(
              currentGlasses: waterGlasses,
              targetGlasses: DietConstants.waterGlassTarget,
              onAdd: onAddWater,
            ),
          ),
        ),

        const SliverPadding(padding: EdgeInsets.only(top: 16)),

        // Surprise Me
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
            child: InkWell(
              onTap: onSurpriseMe,
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF00E5B2), // Slightly lighter mint
                      Color(0xFF00D1A3), // Primary mint
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.auto_awesome, color: Colors.white, size: 28),
                    const SizedBox(width: 12),
                    Text(
                      l10n.surpriseMeButton,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        const SliverPadding(padding: EdgeInsets.only(top: 32)),

        // Meal Timeline Header
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
