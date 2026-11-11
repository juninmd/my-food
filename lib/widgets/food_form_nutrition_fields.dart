import 'package:flutter/material.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/theme/app_tokens.dart';
import 'package:webdiet/utils/nutrition_math.dart';
import 'package:webdiet/widgets/common/macro_tiles.dart';
import 'package:webdiet/widgets/food_form_fields.dart';
import 'package:webdiet/widgets/food_form_section.dart';

/// Calories and macros. Below them, the calories implied by the macros
/// with a one-tap "Use" to fill the field.
class FoodFormNutritionFields extends StatelessWidget {
  final TextEditingController calController;
  final TextEditingController proteinController;
  final TextEditingController carbsController;
  final TextEditingController fatController;

  const FoodFormNutritionFields({
    super.key,
    required this.calController,
    required this.proteinController,
    required this.carbsController,
    required this.fatController,
  });

  int _v(TextEditingController c) => int.tryParse(c.text) ?? 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final t = AppTokens.of(context);
    Widget field(TextEditingController c, String label) => buildTextField(
        context: context,
        controller: c,
        label: label,
        keyboardType: TextInputType.number);

    return FoodFormSection(
      title: l10n.nutritionPer100g,
      icon: Icons.monitor_weight_outlined,
      children: [
        field(calController, l10n.foodCaloriesLabel),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: field(proteinController, l10n.foodProteinLabel)),
          const SizedBox(width: 8),
          Expanded(child: field(carbsController, l10n.foodCarbsLabel)),
          const SizedBox(width: 8),
          Expanded(child: field(fatController, l10n.foodFatLabel)),
        ]),
        const SizedBox(height: 12),
        ListenableBuilder(
          listenable: Listenable.merge(
              [proteinController, carbsController, fatController]),
          builder: (context, _) {
            final p = _v(proteinController),
                c = _v(carbsController),
                f = _v(fatController);
            final kcal = NutritionMath.kcalFromMacros(p, c, f);
            return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MacroDnaBar(protein: p, carbs: c, fat: f),
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(
                      child: Text(
                        kcal > 0
                            ? l10n.macroKcalHint(kcal)
                            : l10n.fillMacrosHint,
                        style: TextStyle(fontSize: 12, color: t.ink2),
                      ),
                    ),
                    if (kcal > 0)
                      TextButton(
                        onPressed: () => calController.text = '$kcal',
                        child: Text(l10n.useValue),
                      ),
                  ]),
                ]);
          },
        ),
      ],
    );
  }
}
