import 'package:flutter/material.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/models/food_item.dart';
import 'package:webdiet/widgets/food_catalog_delete_dialog.dart';
import 'package:webdiet/widgets/macro_badge.dart';

class FoodCatalogCardDetails extends StatelessWidget {
  final FoodItem food;
  final VoidCallback onDelete;

  const FoodCatalogCardDetails({
    super.key,
    required this.food,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      food.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: colorScheme.onSurface,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: colorScheme.error,
                      size: 20,
                    ),
                    onPressed: () {
                      showFoodDeleteDialog(context, l10n, onDelete);
                    },
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.only(left: 8),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                food.description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.3,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildMacroBadge(
                  context,
                  '${food.calories}',
                  Colors.orange.shade800,
                  Colors.orange.shade50,
                  icon: Icons.local_fire_department_outlined,
                  label: l10n.caloriesTitle,
                ),
                buildMacroBadge(
                  context,
                  '${food.protein}g',
                  colorScheme.primary,
                  colorScheme.primary.withValues(alpha: 0.1),
                  label: l10n.macroProtein,
                ),
                buildMacroBadge(
                  context,
                  '${food.carbs}g',
                  Colors.blue.shade700,
                  Colors.blue.shade50,
                  label: l10n.macroCarbs,
                ),
                buildMacroBadge(
                  context,
                  '${food.fat}g',
                  Colors.red.shade700,
                  Colors.red.shade50,
                  label: l10n.macroFat,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
