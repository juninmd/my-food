import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';
import 'package:my_food/models/meal.dart';
import 'package:my_food/data/meal_data.dart';
import 'package:my_food/data/diet_constants.dart';
import 'package:my_food/services/api_service.dart';
import 'package:my_food/widgets/dashboard_view.dart';
import 'package:my_food/widgets/shopping_list_view.dart';
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

  int _nextIntDifferent(int currentIndex, int length, Random random) {
    if (length <= 1) return 0;
    int newIndex = currentIndex;
    while (newIndex == currentIndex) {
      newIndex = random.nextInt(length);
    }
    return newIndex;
  }

  void _surpriseMe() {
    final l10n = AppLocalizations.of(context)!;
    final breakfastOptions = MealData.getBreakfastOptions(l10n);
    final lunchOptions = MealData.getLunchOptions(l10n);
    final dinnerOptions = MealData.getDinnerOptions(l10n);

    setState(() {
      final random = Random();
      _breakfastIndex =
          _nextIntDifferent(_breakfastIndex, breakfastOptions.length, random);
      _lunchIndex = _nextIntDifferent(_lunchIndex, lunchOptions.length, random);
      _dinnerIndex =
          _nextIntDifferent(_dinnerIndex, dinnerOptions.length, random);

      _saveMealPlan(_breakfastIndex, _lunchIndex, _dinnerIndex);

      _quoteFuture = _apiService.fetchQuote();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.surpriseMeFeedback),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showMealSelector(BuildContext context, List<Meal> options, Function(Meal) onSelect) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: 500,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  l10n.selectFoodTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              CarouselSlider(
                options: CarouselOptions(
                  height: 380,
                  autoPlay: false,
                  enlargeCenterPage: true,
                  viewportFraction: 0.8,
                ),
                items: options.map((meal) {
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {
                          onSelect(meal);
                          Navigator.pop(context);
                        },
                        child: _buildCarouselItem(meal),
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCarouselItem(Meal meal) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.asset(
                meal.imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    meal.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    meal.description,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const Spacer(),
                   Text(
                    '${meal.calories} kcal',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
                if (_waterGlasses < _targetGlasses + 5) { // Allow slightly over target
                  _waterGlasses++;
                  _saveWater();
                }
             });
          },
          onEditBreakfast: (meal) => _showMealSelector(context, breakfastOptions, (selected) {
             setState(() {
                _breakfastIndex = breakfastOptions.indexOf(selected);
                _saveSingleMeal('breakfast_index', _breakfastIndex);
             });
          }),
          onEditLunch: (meal) => _showMealSelector(context, lunchOptions, (selected) {
             setState(() {
                _lunchIndex = lunchOptions.indexOf(selected);
                _saveSingleMeal('lunch_index', _lunchIndex);
             });
          }),
          onEditDinner: (meal) => _showMealSelector(context, dinnerOptions, (selected) {
             setState(() {
                _dinnerIndex = dinnerOptions.indexOf(selected);
                _saveSingleMeal('dinner_index', _dinnerIndex);
             });
          }),
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
      body: SafeArea(child: body),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
           BottomNavigationBarItem(
             icon: const Icon(Icons.dashboard_outlined),
             activeIcon: const Icon(Icons.dashboard),
             label: l10n.dashboardTitle
           ),
           BottomNavigationBarItem(
             icon: const Icon(Icons.shopping_cart_outlined),
             activeIcon: const Icon(Icons.shopping_cart),
             label: l10n.shoppingListTitle
           ),
           BottomNavigationBarItem(
             icon: const Icon(Icons.grid_view),
             activeIcon: const Icon(Icons.grid_view_rounded),
             label: l10n.toolsTitle
           ),
        ],
      ),
    );
  }
}
