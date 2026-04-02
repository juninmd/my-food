import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';
import 'package:my_food/models/meal.dart';
import 'package:my_food/data/meal_data.dart';
import 'package:my_food/data/diet_constants.dart';
import 'package:my_food/services/api_service.dart';
import 'package:my_food/services/ai_recommendation_service.dart';
import 'package:my_food/widgets/dashboard_view.dart';
import 'package:my_food/widgets/meal_selector_sheet.dart';
import 'package:my_food/widgets/shopping_list_view.dart';
import 'package:my_food/widgets/surprise_me_dialog.dart';
import 'package:my_food/widgets/tools_view.dart';

class HomePage extends StatefulWidget {
  final ApiService? apiService;

  const HomePage({super.key, this.apiService});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  int _breakfastIndex = 0;
  int _lunchIndex = 0;
  int _dinnerIndex = 0;
  int _waterGlasses = 0;
  final int _targetGlasses = DietConstants.waterGlassTarget;
  late Future<String> _quoteFuture;
  late ApiService _apiService;

  @override
  void initState() {
    super.initState();
    _apiService = widget.apiService ?? ApiService();
    _quoteFuture = _apiService.fetchQuote();
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _waterGlasses = prefs.getInt('water_glasses') ?? 0;
      _breakfastIndex = prefs.getInt('breakfast_index') ?? 0;
      _lunchIndex = prefs.getInt('lunch_index') ?? 0;
      _dinnerIndex = prefs.getInt('dinner_index') ?? 0;
    });
  }

  Future<void> _saveWater() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('water_glasses', _waterGlasses);
  }

  Future<void> _saveMealPlan(
      int breakfastIndex, int lunchIndex, int dinnerIndex) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('breakfast_index', breakfastIndex);
    await prefs.setInt('lunch_index', lunchIndex);
    await prefs.setInt('dinner_index', dinnerIndex);
  }

  Future<void> _saveSingleMeal(String key, int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, index);
  }

  @override
  void dispose() {
    if (widget.apiService == null) {
      _apiService.dispose();
    }
    super.dispose();
  }

  Future<void> _surpriseMe() async {
    final l10n = AppLocalizations.of(context)!;
    final breakfastOptions = MealData.getBreakfastOptions(l10n);
    final lunchOptions = MealData.getLunchOptions(l10n);
    final dinnerOptions = MealData.getDinnerOptions(l10n);

    final quoteFuture = _apiService.fetchQuote();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SurpriseMeDialog(
          quoteFuture: quoteFuture,
          onReveal: () {
            if (!mounted) return;
            setState(() {
              final bestCombination = AiRecommendationService.getBestMealCombination(
                  breakfastOptions, lunchOptions, dinnerOptions, [_breakfastIndex, _lunchIndex, _dinnerIndex]);

              _breakfastIndex = bestCombination[0];
              _lunchIndex = bestCombination[1];
              _dinnerIndex = bestCombination[2];

              _saveMealPlan(_breakfastIndex, _lunchIndex, _dinnerIndex);

              _quoteFuture = quoteFuture;
            });
          },
        );
      },
    );
  }

  void _showMealSelector(
      BuildContext context, List<Meal> options, Function(Meal) onSelect) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return MealSelectorSheet(
          options: options,
          onSelect: onSelect,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final breakfastOptions = MealData.getBreakfastOptions(l10n);
    final lunchOptions = MealData.getLunchOptions(l10n);
    final dinnerOptions = MealData.getDinnerOptions(l10n);

    if (_breakfastIndex >= breakfastOptions.length) _breakfastIndex = 0;
    if (_lunchIndex >= lunchOptions.length) _lunchIndex = 0;
    if (_dinnerIndex >= dinnerOptions.length) _dinnerIndex = 0;

    final breakfast = breakfastOptions[_breakfastIndex];
    final lunch = lunchOptions[_lunchIndex];
    final dinner = dinnerOptions[_dinnerIndex];

    final allIngredients = [
      ...breakfast.ingredients,
      ...lunch.ingredients,
      ...dinner.ingredients,
    ];

    Widget body;
    switch (_currentIndex) {
      case 0:
        body = DashboardView(
          quoteFuture: _quoteFuture,
          breakfast: breakfast,
          lunch: lunch,
          dinner: dinner,
          waterGlasses: _waterGlasses,
          onAddWater: () {
            setState(() {
              if (_waterGlasses < _targetGlasses + 5) {
                // Allow slightly over target
                _waterGlasses++;
                _saveWater();
              }
            });
          },
          onEditBreakfast: (meal) =>
              _showMealSelector(context, breakfastOptions, (selected) {
            setState(() {
              _breakfastIndex = breakfastOptions.indexOf(selected);
              _saveSingleMeal('breakfast_index', _breakfastIndex);
            });
          }),
          onEditLunch: (meal) =>
              _showMealSelector(context, lunchOptions, (selected) {
            setState(() {
              _lunchIndex = lunchOptions.indexOf(selected);
              _saveSingleMeal('lunch_index', _lunchIndex);
            });
          }),
          onEditDinner: (meal) =>
              _showMealSelector(context, dinnerOptions, (selected) {
            setState(() {
              _dinnerIndex = dinnerOptions.indexOf(selected);
              _saveSingleMeal('dinner_index', _dinnerIndex);
            });
          }),
          onSurpriseMe: _surpriseMe,
        );
        break;
      case 1:
        body = ShoppingListView(ingredients: allIngredients);
        break;
      case 2:
        body = ToolsView(onSurpriseMe: () {
          _surpriseMe();
          setState(() {
            _currentIndex = 0; // Go back to dashboard
          });
        });
        break;
      default:
        body = const SizedBox.shrink();
    }

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            return Row(
              children: [
                NavigationRail(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  labelType: NavigationRailLabelType.all,
                  destinations: [
                    NavigationRailDestination(
                      icon: const Icon(Icons.dashboard_outlined),
                      selectedIcon: const Icon(Icons.dashboard_rounded),
                      label: Text(l10n.dashboardTitle),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.shopping_bag_outlined),
                      selectedIcon: const Icon(Icons.shopping_bag_rounded),
                      label: Text(l10n.shoppingListTitle),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.grid_view),
                      selectedIcon: const Icon(Icons.grid_view_rounded),
                      label: Text(l10n.toolsTitle),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: SafeArea(child: body)),
              ],
            );
          } else {
            return SafeArea(child: body);
          }
        },
      ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            return const SizedBox.shrink();
          }
          return Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                      icon: const Icon(Icons.dashboard_outlined),
                      activeIcon: const Icon(Icons.dashboard_rounded),
                      label: l10n.dashboardTitle),
                  BottomNavigationBarItem(
                      icon: const Icon(Icons.shopping_bag_outlined),
                      activeIcon: const Icon(Icons.shopping_bag_rounded),
                      label: l10n.shoppingListTitle),
                  BottomNavigationBarItem(
                      icon: const Icon(Icons.grid_view),
                      activeIcon: const Icon(Icons.grid_view_rounded),
                      label: l10n.toolsTitle),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
