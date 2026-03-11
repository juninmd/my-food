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
        _buildTimelineItem(
            context, l10n.mealBreakfast, breakfast, onEditBreakfast, "08:00",
            isFirst: true),
        _buildTimelineItem(
            context, l10n.mealLunch, lunch, onEditLunch, "12:00"),
        _buildTimelineItem(
            context, l10n.mealDinner, dinner, onEditDinner, "19:00",
            isLast: true),
      ],
    );
  }

  Widget _buildTimelineItem(BuildContext context, String title, Meal meal,
      Function(Meal) onEdit, String time,
      {bool isFirst = false, bool isLast = false}) {
    final colorScheme = Theme.of(context).colorScheme;

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
                padding: const EdgeInsets.only(top: 28.0),
                child: Text(
                  time,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.primary,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            // Line decoration
            SizedBox(
              width: 20,
              child: Column(
                children: [
                  // Top line segment (only if not first)
                  if (!isFirst)
                    Container(
                      width: 1,
                      height: 28, // Connects to the previous item
                      color: Theme.of(context).dividerColor,
                    )
                  else
                    const SizedBox(height: 28),

                  // Dot
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: colorScheme.primary,
                          width: 2), // Thicker border to stand out
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),

                  // Bottom line segment (extends to next item)
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Meal Card
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ModernMealCard(
                  title: title,
                  meal: meal,
                  onEdit: () => onEdit(meal),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
