import 'package:flutter/material.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/models/food_item.dart';
import 'package:webdiet/widgets/food_catalog_delete_dialog.dart';
import 'package:webdiet/widgets/macro_badge.dart';
import 'package:webdiet/widgets/macro_distribution_bar.dart';

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
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
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
                      showFoodDeleteDialog(context, AppLocalizations.of(context)!, onDelete);
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
          Builder(
            builder: (context) {
              final proteinCals = food.protein * 4.0;
              final carbsCals = food.carbs * 4.0;
              final fatCals = food.fat * 9.0;
              final totalCals = proteinCals + carbsCals + fatCals;

              double pPct = 0, cPct = 0, fPct = 0;
              if (totalCals > 0) {
                pPct = proteinCals / totalCals;
                cPct = carbsCals / totalCals;
                fPct = fatCals / totalCals;
              }

              return Container(
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
                child: Column(
                  children: [
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      alignment: WrapAlignment.center,
                      children: [
                        buildMacroBadge(
                          context,
                          '${food.calories}',
                          Colors.orange.shade800,
                          Colors.orange.withValues(alpha: 0.08),
                          icon: Icons.local_fire_department_rounded,
                          label: AppLocalizations.of(context)!.caloriesTitle,
                        ),
                        buildMacroBadge(
                          context,
                          '${food.protein}g',
                          colorScheme.primary,
                          colorScheme.primary.withValues(alpha: 0.08),
                          icon: Icons.fitness_center_rounded,
                          label: AppLocalizations.of(context)!.macroProtein,
                        ),
                        buildMacroBadge(
                          context,
                          '${food.carbs}g',
                          Colors.blue.shade800,
                          Colors.blue.withValues(alpha: 0.08),
                          icon: Icons.bolt_rounded,
                          label: AppLocalizations.of(context)!.macroCarbs,
                        ),
                        buildMacroBadge(
                          context,
                          '${food.fat}g',
                          Colors.red.shade800,
                          Colors.red.withValues(alpha: 0.08),
                          icon: Icons.water_drop_rounded,
                          label: AppLocalizations.of(context)!.macroFat,
                        ),
                      ],
                    ),
                    if (totalCals > 0) ...[
                      const SizedBox(height: 8),
                      MacroDistributionBar(
                        pPct: pPct,
                        cPct: cPct,
                        fPct: fPct,
                        colorScheme: colorScheme,
                        height: 4.0,
                        showLabels: false,
                        showTitle: false,
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
