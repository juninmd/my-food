import 'package:flutter/material.dart';
import 'package:webdiet/models/day_plan.dart';
import 'package:webdiet/models/meal.dart';
import 'package:webdiet/pages/food_catalog_page.dart';
import 'package:webdiet/widgets/dashboard_view.dart';
import 'package:webdiet/widgets/shopping_list_view.dart';
import 'package:webdiet/widgets/tools_view.dart';

/// Picks the view of the selected tab and wires it to the home state.
class HomeBody extends StatelessWidget {
  final int currentIndex;
  final DayPlan plan;
  final Map<MealSlot, List<Meal>> options;
  final Map<MealSlot, int> mealIndex;
  final int water;
  final Set<String> checked;
  final Future<String> quoteFuture;
  final Animation<double> roll;
  final VoidCallback onSurpriseMe;
  final VoidCallback onRefreshQuote;
  final ValueChanged<int> onSetWater;
  final void Function(MealSlot slot, int index) onSelectMeal;
  final ValueChanged<Set<String>> onCheckedChanged;
  final ValueChanged<int> onGoTo;

  const HomeBody({
    super.key,
    required this.currentIndex,
    required this.plan,
    required this.options,
    required this.mealIndex,
    required this.water,
    required this.checked,
    required this.quoteFuture,
    required this.roll,
    required this.onSurpriseMe,
    required this.onRefreshQuote,
    required this.onSetWater,
    required this.onSelectMeal,
    required this.onCheckedChanged,
    required this.onGoTo,
  });

  @override
  Widget build(BuildContext context) {
    switch (currentIndex) {
      case 0:
        return DashboardView(
          plan: plan,
          options: options,
          mealIndex: mealIndex,
          water: water,
          quoteFuture: quoteFuture,
          roll: roll,
          onSurpriseMe: onSurpriseMe,
          onRefreshQuote: onRefreshQuote,
          onSetWater: onSetWater,
          onSelectMeal: onSelectMeal,
        );
      case 1:
        return ShoppingListView(
          ingredients: plan.ingredients,
          checked: checked,
          onCheckedChanged: onCheckedChanged,
        );
      case 2:
        return FoodCatalogPage(
          bottomInset: MediaQuery.sizeOf(context).width > 800 ? 0 : 76,
        );
      case 3:
        return ToolsView(
            onSurpriseMe: onSurpriseMe, onOpenCatalog: () => onGoTo(2));
      default:
        return const SizedBox.shrink();
    }
  }
}
