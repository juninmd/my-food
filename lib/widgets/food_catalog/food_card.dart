import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/models/food_item.dart';
import 'package:webdiet/theme/app_tokens.dart';
import 'package:webdiet/theme/app_type.dart';
import 'package:webdiet/widgets/common/macro_tiles.dart';
import 'package:webdiet/widgets/common/meal_plate.dart';
import 'package:webdiet/widgets/common/pressable.dart';

/// Decoded photo of a food, or null when it has none or it is unreadable.
Uint8List? foodImage(FoodItem food) {
  if (food.imageBase64 == null) return null;
  try {
    return base64Decode(food.imageBase64!);
  } catch (_) {
    return null;
  }
}

/// Catalog card: plate (or photo), name, kcal and the macro DNA bar.
class FoodCard extends StatelessWidget {
  final FoodItem food;
  final VoidCallback onTap;

  const FoodCard({super.key, required this.food, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Pressable(
      onTap: onTap,
      semanticLabel: food.name,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: t.card(radius: 22),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            MealPlate(
              protein: food.protein,
              carbs: food.carbs,
              fat: food.fat,
              size: 52,
              image: foodImage(food),
            ),
            const Spacer(),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('${food.calories}',
                  style: AppType.display(22, color: t.ink)),
              Text('kcal', style: AppType.data(10, color: t.ink2)),
            ]),
          ]),
          const Spacer(),
          Text(food.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppType.display(15, color: t.ink)),
          const SizedBox(height: 2),
          Text(
            food.description.isEmpty ? l10n.noDescription : food.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: t.ink2),
          ),
          const SizedBox(height: 8),
          Text(
            '${l10n.macroProtein[0]}${food.protein}g · '
            '${l10n.macroCarbs[0]}${food.carbs}g · '
            '${l10n.macroFat[0]}${food.fat}g',
            style: AppType.data(11, color: t.ink2, weight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          MacroDnaBar(protein: food.protein, carbs: food.carbs, fat: food.fat),
        ]),
      ),
    );
  }
}
