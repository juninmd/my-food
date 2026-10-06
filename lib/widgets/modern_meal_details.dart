import 'package:flutter/material.dart';
import 'package:webdiet/models/meal.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/widgets/macro_badge.dart';

class ModernMealDetails extends StatelessWidget {
  final Meal meal;
  final String title;
  final VoidCallback onEdit;

  const ModernMealDetails({
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            color: colorScheme.primary,
            fontWeight: FontWeight.w800,
            fontSize: 10,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          meal.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 16,
            height: 1.2,
            color: colorScheme.onSurface,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Text(
          meal.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.grey.shade600,
            height: 1.3,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            buildMacroBadge(
              context,
              "${meal.calories}",
              Colors.orange.shade800,
              Colors.orange.withValues(alpha: 0.08),
              icon: Icons.local_fire_department_rounded,
            ),
            buildMacroBadge(
              context,
              "${meal.protein}g",
              colorScheme.primary,
              colorScheme.primary.withValues(alpha: 0.08),
              icon: Icons.fitness_center_rounded,
            ),
            buildMacroBadge(
              context,
              "${meal.carbs}g",
              Colors.blue.shade800,
              Colors.blue.withValues(alpha: 0.08),
              icon: Icons.bolt_rounded,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: onEdit,
            icon: Icon(Icons.swap_horiz_rounded,
                size: 16, color: colorScheme.primary),
            label: Text(
              l10n.swapMeal.toUpperCase(),
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.w900,
                fontSize: 12,
                letterSpacing: 1.0,
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ),
      ],
    );
  }
}
