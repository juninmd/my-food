import 'package:flutter/material.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/widgets/food_form_fields.dart';
import 'package:webdiet/widgets/food_form_section.dart';
import 'package:webdiet/widgets/macro_distribution_bar.dart';

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
            color: colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.2,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.surfaceContainerHighest,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isSmall = constraints.maxWidth < 300;
              final itemWidth = isSmall ? constraints.maxWidth : (constraints.maxWidth - 16) / 2;
              return ListenableBuilder(
                listenable: Listenable.merge([
                  proteinController,
                  carbsController,
                  fatController,
                ]),
                builder: (context, child) {
                  final protein = double.tryParse(proteinController.text) ?? 0.0;
                  final carbs = double.tryParse(carbsController.text) ?? 0.0;
                  final fat = double.tryParse(fatController.text) ?? 0.0;

                  final proteinCals = protein * 4.0;
                  final carbsCals = carbs * 4.0;
                  final fatCals = fat * 9.0;
                  final totalCals = proteinCals + carbsCals + fatCals;

                  double pPct = 0, cPct = 0, fPct = 0;
                  if (totalCals > 0) {
                    pPct = proteinCals / totalCals;
                    cPct = carbsCals / totalCals;
                    fPct = fatCals / totalCals;
                  }

                  return Column(
                    children: [
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          SizedBox(
                            width: itemWidth,
                            child: buildTextField(
                              context: context,
                              controller: calController,
                              label: l10n.foodCaloriesLabel,
                              prefixIcon: Icons.local_fire_department_outlined,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          SizedBox(
                            width: itemWidth,
                            child: buildTextField(
                              context: context,
                              controller: proteinController,
                              label: l10n.foodProteinLabel,
                              prefixIcon: Icons.fitness_center_outlined,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          SizedBox(
                            width: itemWidth,
                            child: buildTextField(
                              context: context,
                              controller: carbsController,
                              label: l10n.foodCarbsLabel,
                              prefixIcon: Icons.grain_outlined,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          SizedBox(
                            width: itemWidth,
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
                      if (totalCals > 0) ...[
                        const SizedBox(height: 24),
                        MacroDistributionBar(
                          pPct: pPct,
                          cPct: cPct,
                          fPct: fPct,
                          colorScheme: colorScheme,
                          height: 12.0,
                          showLabels: true,
                          showTitle: true,
                        ),
                      ],
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
