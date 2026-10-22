import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/models/food_item.dart';
import 'package:webdiet/widgets/food_catalog_delete_dialog.dart';

/// UI Card com design clean/moderno (sombras, s/ bordas pesadas)
/// para que a tela seja "agradável também aos nutricionistas".
class FoodCatalogCard extends StatelessWidget {
  final FoodItem food;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const FoodCatalogCard({
    super.key,
    required this.food,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      // Reformulate for a more aesthetic/productive feel
      decoration: BoxDecoration(
        color: colorScheme.surface, // Clean background
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04), // Softer modern shadow
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  image: food.imageBase64 != null
                      ? DecorationImage(
                          image: MemoryImage(base64Decode(food.imageBase64!)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: food.imageBase64 == null
                    ? Icon(
                        Icons.fastfood_outlined,
                        color: colorScheme.primary,
                        size: 40,
                      )
                    : null,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            maxLines: 1,
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
                          padding: EdgeInsets.zero,
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
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
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
                          _buildMacroStat(
                            context,
                            '${food.calories}',
                            l10n.caloriesTitle,
                            Colors.orange.shade800,
                          ),
                          _buildMacroStat(
                            context,
                            '${food.protein}g',
                            l10n.macroProtein,
                            colorScheme.primary,
                          ),
                          _buildMacroStat(
                            context,
                            '${food.carbs}g',
                            l10n.macroCarbs,
                            Colors.blue.shade700,
                          ),
                          _buildMacroStat(
                            context,
                            '${food.fat}g',
                            l10n.macroFat,
                            Colors.red.shade700,
                          ),
                        ],
                      ),
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

  Widget _buildMacroStat(
    BuildContext context,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 14,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
