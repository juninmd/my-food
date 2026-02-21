import 'package:flutter/material.dart';
import 'package:my_food/models/meal.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';

class ModernMealCard extends StatelessWidget {
  final Meal meal;
  final String title;
  final VoidCallback onEdit;

  const ModernMealCard({
    super.key,
    required this.meal,
    required this.title,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(right: 24, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onEdit,
          splashColor: colorScheme.primary.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Increased padding
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image - Larger and prominent
                Hero(
                  tag: 'meal_${title}_${meal.name}',
                  child: Container(
                    width: 110, // Increased size
                    height: 110, // Increased size
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage(meal.imagePath),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Title & Calories
                      Text(
                        title.toUpperCase(),
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        meal.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold, // Bolder
                          fontSize: 16, // Larger
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      // Macros
                      Row(
                        children: [
                          _buildMacroPill(context, "P", "${meal.protein}g"),
                          const SizedBox(width: 8),
                          _buildMacroPill(context, "C", "${meal.carbs}g"),
                          const SizedBox(width: 8),
                          _buildMacroPill(context, "F", "${meal.fat}g"),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Change Button - Outlined Style with Icon
                      SizedBox(
                        height: 36,
                        child: OutlinedButton.icon(
                          onPressed: onEdit,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.3)),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.swap_horiz, size: 18),
                          label: Text(
                            l10n.swapMeal,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMacroPill(BuildContext context, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(width: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
