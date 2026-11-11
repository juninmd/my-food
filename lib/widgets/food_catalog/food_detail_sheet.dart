import 'package:flutter/material.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/models/food_item.dart';
import 'package:webdiet/theme/app_motion.dart';
import 'package:webdiet/theme/app_tokens.dart';
import 'package:webdiet/theme/app_type.dart';
import 'package:webdiet/widgets/common/macro_tiles.dart';
import 'package:webdiet/widgets/common/meal_plate.dart';
import 'package:webdiet/widgets/food_catalog/food_card.dart';

/// Food details with Edit and a two-step Delete: the first tap arms the
/// button, the second one deletes.
class FoodDetailSheet extends StatefulWidget {
  final FoodItem food;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const FoodDetailSheet({
    super.key,
    required this.food,
    required this.onEdit,
    required this.onDelete,
  });

  static Future<void> show(BuildContext context,
      {required FoodItem food,
      required VoidCallback onEdit,
      required VoidCallback onDelete}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) =>
          FoodDetailSheet(food: food, onEdit: onEdit, onDelete: onDelete),
    );
  }

  @override
  State<FoodDetailSheet> createState() => _FoodDetailSheetState();
}

class _FoodDetailSheetState extends State<FoodDetailSheet> {
  bool _armed = false;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final l10n = AppLocalizations.of(context)!;
    final f = widget.food;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Center(
          child: MealPlate(
            protein: f.protein,
            carbs: f.carbs,
            fat: f.fat,
            size: 110,
            image: foodImage(f),
            spinIn: true,
          ),
        ),
        const SizedBox(height: 12),
        Text(f.name,
            textAlign: TextAlign.center,
            style: AppType.display(26, color: t.ink)),
        const SizedBox(height: 4),
        Text(
          f.description.isEmpty ? l10n.noDescription : f.description,
          textAlign: TextAlign.center,
          style: TextStyle(color: t.ink2),
        ),
        const SizedBox(height: 18),
        MacroTiles(
            calories: f.calories,
            protein: f.protein,
            carbs: f.carbs,
            fat: f.fat),
        const SizedBox(height: 18),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context);
            widget.onEdit();
          },
          icon: const Icon(Icons.edit_outlined),
          label: Text(l10n.editButton),
        ),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: AppMotion.of(context, AppMotion.tick),
          decoration: BoxDecoration(
            color: _armed ? t.protein : t.protein.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: _armed ? Colors.white : t.protein,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () {
              if (!_armed) return setState(() => _armed = true);
              Navigator.pop(context);
              widget.onDelete();
            },
            icon: const Icon(Icons.delete_outline),
            label: Text(_armed ? l10n.tapAgainToDelete : l10n.deleteFood,
                style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ),
      ]),
    );
  }
}
