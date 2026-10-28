import 'package:flutter/material.dart';
import 'package:webdiet/models/food_item.dart';
import 'package:webdiet/widgets/food_catalog_card_image.dart';
import 'package:webdiet/widgets/food_catalog_card_details.dart';

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
              Expanded(
                flex: 3,
                child: FoodCatalogCardImage(
                  imageBase64: food.imageBase64,
                  colorScheme: colorScheme,
                ),
              ),
              Expanded(
                flex: 4,
                child: FoodCatalogCardDetails(
                  food: food,
                  onDelete: onDelete,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
