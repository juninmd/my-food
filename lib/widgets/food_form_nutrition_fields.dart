import 'package:flutter/material.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/widgets/food_form_fields.dart';
import 'package:webdiet/widgets/food_form_section.dart';

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FoodFormSection(
      title: l10n.nutritionPer100g,
      icon: Icons.monitor_weight_outlined,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.surfaceContainerHighest),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: buildTextField(
                      context: context,
                      controller: calController,
                      label: l10n.foodCaloriesLabel,
                      prefixIcon: Icons.local_fire_department_outlined,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: buildTextField(
                      context: context,
                      controller: proteinController,
                      label: l10n.foodProteinLabel,
                      prefixIcon: Icons.fitness_center_outlined,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: buildTextField(
                      context: context,
                      controller: carbsController,
                      label: l10n.foodCarbsLabel,
                      prefixIcon: Icons.grain_outlined,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: buildTextField(
                      context: context,
                      controller: fatController,
                      label: l10n.foodFatLabel,
                      prefixIcon: Icons.water_drop_outlined,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
