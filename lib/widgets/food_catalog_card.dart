import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';
import 'package:my_food/models/food_item.dart';

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
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    image: food.imageBase64 != null
                        ? DecorationImage(
                            image: MemoryImage(base64Decode(food.imageBase64!)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: food.imageBase64 == null
                      ? Icon(Icons.fastfood_outlined,
                          color: colorScheme.primary, size: 32)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
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
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_outline,
                                color: colorScheme.error, size: 20),
                            onPressed: () {
                              _showDeleteDialog(context, l10n);
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
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          _buildMacroBadge(
                              context,
                              '${food.calories} kcal',
                              Colors.orange.shade800,
                              Colors.orange.withValues(alpha: 0.1)),
                          _buildMacroBadge(
                              context,
                              '${food.protein}g P',
                              colorScheme.primary,
                              colorScheme.primary.withValues(alpha: 0.1)),
                        ],
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

  Widget _buildMacroBadge(
      BuildContext context, String text, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(l10n.deleteFood),
        content: Text(l10n.deleteConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'), // Could be localized, but following existing code for now
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            child: Text(l10n.deleteFood),
          ),
        ],
      ),
    );
  }
}
