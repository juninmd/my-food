import 'package:flutter/material.dart';
import 'package:my_food/models/meal.dart';
import 'package:my_food/widgets/modern_meal_card.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';

class MealTimeline extends StatelessWidget {
  final Meal breakfast;
  final Meal lunch;
  final Meal dinner;
  final Function(Meal) onEditBreakfast;
  final Function(Meal) onEditLunch;
  final Function(Meal) onEditDinner;

  const MealTimeline({
    super.key,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.onEditBreakfast,
    required this.onEditLunch,
    required this.onEditDinner,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        _buildTimelineItem(context, l10n.mealBreakfast, breakfast, onEditBreakfast, "08:00"),
        _buildTimelineItem(context, l10n.mealLunch, lunch, onEditLunch, "12:00"),
        _buildTimelineItem(context, l10n.mealDinner, dinner, onEditDinner, "19:00"),
      ],
    );
  }

  Widget _buildTimelineItem(
      BuildContext context, String title, Meal meal, Function(Meal) onEdit, String time) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 0, bottom: 8),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Time Column
            SizedBox(
              width: 50,
              child: Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Text(
                  time,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            // Line decoration
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 24), // Align with time text
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.grey.withValues(alpha: 0.1),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            // Meal Card
            Expanded(
              child: ModernMealCard(
                title: title,
                meal: meal,
                onEdit: () => onEdit(meal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
