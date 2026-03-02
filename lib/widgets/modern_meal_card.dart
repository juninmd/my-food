import 'package:flutter/material.dart';
import 'package:my_food/models/meal.dart';
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(right: 24, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28), // Even rounder
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04), // Softer shadow
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(28),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Image Section
              Stack(
                children: [
                  Hero(
                    tag: 'meal_${title}_${meal.name}',
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(meal.imagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.0),
                                Colors.black.withValues(
                                    alpha: 0.2), // Slightly darker for contrast
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Text(
                        title.toUpperCase(),
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Material(
                      color: Colors.white.withValues(
                          alpha: 0.95), // White button instead of primary color
                      borderRadius: BorderRadius.circular(20),
                      elevation: 4,
                      child: InkWell(
                        onTap: onEdit,
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.swap_horiz_rounded,
                                size: 16,
                                color: colorScheme
                                    .primary, // Icon is primary color
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "SWAP",
                                style: TextStyle(
                                  color: colorScheme
                                      .primary, // Text is primary color
                                  fontWeight: FontWeight.w800,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Bottom Details Section
              Padding(
                padding: const EdgeInsets.all(24.0), // Increased padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800, // Bolder
                        fontSize: 18,
                        height: 1.2,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      meal.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                        height: 1.5,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _buildMacroBadge(
                          context,
                          Icons.local_fire_department_rounded,
                          "${meal.calories}",
                          Colors.orange.shade800,
                          Colors.orange.shade50,
                        ),
                        const SizedBox(width: 8),
                        _buildMacroBadge(
                          context,
                          Icons.fitness_center_rounded,
                          "${meal.protein}g", // Removed 'P'
                          colorScheme.primary,
                          colorScheme.primary.withValues(alpha: 0.1),
                        ),
                        const SizedBox(width: 8),
                        _buildMacroBadge(
                          context,
                          Icons.bolt_rounded,
                          "${meal.carbs}g", // Removed 'C'
                          Colors.blue.shade800,
                          Colors.blue.shade50,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMacroBadge(BuildContext context, IconData icon, String text,
      Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
