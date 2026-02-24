import 'package:flutter/material.dart';
import 'package:my_food/models/meal.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';
import 'package:my_food/pages/meal_detail_page.dart';

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
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MealDetailPage(
                  meal: meal,
                  onSwap: onEdit,
                  heroTag: 'meal_${title}_${meal.name}',
                ),
              ),
            );
          },
          splashColor: colorScheme.primary.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image - Large, rounded, subtle shadow
                Hero(
                  tag: 'meal_${title}_${meal.name}',
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage(meal.imagePath),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 10,
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
                      // Header Row (Title & Time/Type)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          title.toUpperCase(),
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Meal Name
                      Text(
                        meal.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          height: 1.2,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      // Macros
                      Row(
                        children: [
                          Icon(Icons.local_fire_department_rounded, size: 14, color: Colors.orange),
                          const SizedBox(width: 4),
                          _buildMacroText(context, "${meal.calories}", isBold: true),
                          const SizedBox(width: 12),
                          Icon(Icons.fitness_center_rounded, size: 14, color: colorScheme.primary),
                          const SizedBox(width: 4),
                          _buildMacroText(context, "${meal.protein}g P"),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Action Button
                      SizedBox(
                        height: 32,
                        child: OutlinedButton.icon(
                          onPressed: onEdit,
                          icon: const Icon(Icons.swap_horiz_rounded, size: 16),
                          label: Text(
                             l10n.swapMeal,
                             style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
                            foregroundColor: colorScheme.onSurface,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
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

  Widget _buildMacroText(BuildContext context, String text, {bool isBold = false}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
        color: isBold ? Theme.of(context).colorScheme.primary : Colors.grey.shade600,
      ),
    );
  }
}
