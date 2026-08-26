import 'package:flutter/material.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';
import 'package:my_food/data/meal_data.dart';
import 'package:my_food/data/diet_constants.dart';
import 'package:my_food/widgets/dashboard_view.dart';
import 'package:my_food/widgets/shopping_list_view.dart';
import 'package:my_food/widgets/tools_view.dart';
import 'package:my_food/widgets/meal_selector_sheet.dart';
import 'package:my_food/pages/food_catalog_page.dart';

class HomeBody extends StatelessWidget {
  final int currentIndex;
  final int breakfastIndex;
  final int lunchIndex;
  final int dinnerIndex;
  final int waterGlasses;
  final Future<String> quoteFuture;
  final VoidCallback onSurpriseMe;
  final Function(int) onUpdateWater;
  final Function(int) onUpdateBreakfast;
  final Function(int) onUpdateLunch;
  final Function(int) onUpdateDinner;
  final Function(int) onUpdateIndex;

  const HomeBody({
    super.key,
    required this.currentIndex,
    required this.breakfastIndex,
    required this.lunchIndex,
    required this.dinnerIndex,
    required this.waterGlasses,
    required this.quoteFuture,
    required this.onSurpriseMe,
    required this.onUpdateWater,
    required this.onUpdateBreakfast,
    required this.onUpdateLunch,
    required this.onUpdateDinner,
    required this.onUpdateIndex,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final breakfastOptions = MealData.getBreakfastOptions(l10n);
    final lunchOptions = MealData.getLunchOptions(l10n);
    final dinnerOptions = MealData.getDinnerOptions(l10n);

    int safeBreakfast = breakfastIndex >= breakfastOptions.length ? 0 : breakfastIndex;
    int safeLunch = lunchIndex >= lunchOptions.length ? 0 : lunchIndex;
    int safeDinner = dinnerIndex >= dinnerOptions.length ? 0 : dinnerIndex;

    switch (currentIndex) {
      case 0:
        return DashboardView(
          quoteFuture: quoteFuture,
          breakfast: breakfastOptions[safeBreakfast],
          lunch: lunchOptions[safeLunch],
          dinner: dinnerOptions[safeDinner],
          waterGlasses: waterGlasses,
          onAddWater: () {
            if (waterGlasses < DietConstants.waterGlassTarget + 5) {
              onUpdateWater(waterGlasses + 1);
            }
          },
          onEditBreakfast: (_) => MealSelectorSheet.show(context, breakfastOptions, (selected) {
            onUpdateBreakfast(breakfastOptions.indexOf(selected));
          }),
          onEditLunch: (_) => MealSelectorSheet.show(context, lunchOptions, (selected) {
            onUpdateLunch(lunchOptions.indexOf(selected));
          }),
          onEditDinner: (_) => MealSelectorSheet.show(context, dinnerOptions, (selected) {
            onUpdateDinner(dinnerOptions.indexOf(selected));
          }),
          onSurpriseMe: onSurpriseMe,
        );
      case 1:
        return ShoppingListView(
          ingredients: [
            ...breakfastOptions[safeBreakfast].ingredients,
            ...lunchOptions[safeLunch].ingredients,
            ...dinnerOptions[safeDinner].ingredients,
          ],
        );
      case 2:
        return const FoodCatalogPage();
      case 3:
        return ToolsView(onSurpriseMe: () {
          onSurpriseMe();
          onUpdateIndex(0);
        });
      default:
        return const SizedBox.shrink();
    }
  }
}
