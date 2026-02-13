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
        _buildTimelineItem(context, l10n.mealBreakfast, breakfast, onEditBreakfast),
        _buildTimelineItem(context, l10n.mealLunch, lunch, onEditLunch),
        _buildTimelineItem(context, l10n.mealDinner, dinner, onEditDinner),
      ],
    );
  }

  Widget _buildTimelineItem(
      BuildContext context, String title, Meal meal, Function(Meal) onEdit) {
    return ModernMealCard(
      title: title,
      meal: meal,
      onEdit: () => onEdit(meal),
    );
  }
}
