import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';
import '../models/meal.dart';
import '../data/meal_data.dart';
import '../data/diet_constants.dart';
import '../services/api_service.dart';
import 'shopping_list_page.dart';
import 'bmi_page.dart';
import 'random_recipe_page.dart';

/// The main page of the application, responsible for displaying meal plans,
/// tracking water intake, and showing nutritional progress.
class MealPage extends StatefulWidget {
  /// Optional [ApiService] for dependency injection, primarily for testing.
  final ApiService? apiService;

  const MealPage({super.key, this.apiService});

  @override
  State<MealPage> createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
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

  void _openShoppingList(Meal breakfast, Meal lunch, Meal dinner) {
    List<String> allIngredients = [];
    allIngredients.addAll(breakfast.ingredients);
    allIngredients.addAll(lunch.ingredients);
    allIngredients.addAll(dinner.ingredients);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShoppingListPage(ingredients: allIngredients),
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

    int totalCalories = breakfast.calories + lunch.calories + dinner.calories;
    int totalProtein = breakfast.protein + lunch.protein + dinner.protein;
    int totalCarbs = breakfast.carbs + lunch.carbs + dinner.carbs;
    int totalFat = breakfast.fat + lunch.fat + dinner.fat;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => _openShoppingList(breakfast, lunch, dinner),
            tooltip: l10n.shoppingListTitle,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                l10n.menuTitle,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calculate),
              title: Text(l10n.bmiTitle),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BMICalculatorPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.restaurant_menu),
              title: Text(l10n.randomRecipeTitle),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RandomRecipePage()),
                );
              },
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 80),
        children: [
          _buildDailySummary(context, l10n, totalCalories, totalProtein, totalCarbs, totalFat),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(l10n.mealPageTitle, style: Theme.of(context).textTheme.headlineSmall),
          ),

          _buildMealCard(
            context,
            l10n.mealBreakfast,
            breakfast,
            breakfastOptions,
            (meal) {
              final index = breakfastOptions.indexOf(meal);
              setState(() {
                _breakfastIndex = index;
                _saveSingleMeal('breakfast_index', index);
              });
            },
          ),
          _buildMealCard(
            context,
            l10n.mealLunch,
            lunch,
            lunchOptions,
            (meal) {
              final index = lunchOptions.indexOf(meal);
              setState(() {
                _lunchIndex = index;
                _saveSingleMeal('lunch_index', index);
              });
            },
          ),
          _buildMealCard(
            context,
            l10n.mealDinner,
            dinner,
            dinnerOptions,
            (meal) {
              final index = dinnerOptions.indexOf(meal);
              setState(() {
                _dinnerIndex = index;
                _saveSingleMeal('dinner_index', index);
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _surpriseMe,
        icon: const Icon(Icons.auto_awesome),
        label: Text(l10n.surpriseMeButton),
      ),
    );
  }

  Widget _buildDailySummary(BuildContext context, AppLocalizations l10n, int calories, int protein, int carbs, int fat) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
             FutureBuilder<String>(
                future: _quoteFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        '"${snapshot.data!}"',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.dailyHydration, style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(_targetGlasses, (index) {
                        bool filled = index < _waterGlasses;
                        return GestureDetector(
                          onTap: () {
                             setState(() {
                               if (filled && index == _waterGlasses - 1) {
                                  _waterGlasses = index;
                               } else if (!filled && index == _waterGlasses) {
                                  _waterGlasses = index + 1;
                               } else {
                                  // Simplified toggle: just set to index + 1
                                  _waterGlasses = index + 1;
                               }
                               _saveWater();
                             });
                          },
                          child: Icon(
                            filled ? Icons.water_drop : Icons.water_drop_outlined,
                            color: filled ? Colors.blue : Colors.grey,
                            size: 24,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 4),
                    Text('${_waterGlasses * 250}ml / ${_targetGlasses * 250}ml', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCompactMacro(l10n.totalCalories(calories), calories, 2500, Colors.blueGrey, isCalorie: true), // Assuming 2500 target for calc visualization
                _buildCompactMacro(l10n.macroProtein, protein, DietConstants.proteinTarget, Colors.redAccent),
                _buildCompactMacro(l10n.macroCarbs, carbs, DietConstants.carbsTarget, Colors.orangeAccent),
                _buildCompactMacro(l10n.macroFat, fat, DietConstants.fatTarget, Colors.yellow[800]!),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactMacro(String label, int value, int target, Color color, {bool isCalorie = false}) {
     double progress = target > 0 ? value / target : 0;
     if (progress > 1.0) progress = 1.0;

     return Column(
       children: [
         Stack(
           alignment: Alignment.center,
           children: [
             SizedBox(
               height: 40,
               width: 40,
               child: CircularProgressIndicator(
                 value: progress,
                 backgroundColor: color.withValues(alpha: 0.2),
                 color: color,
                 strokeWidth: 4,
               ),
             ),
             if (!isCalorie)
                Text('${(progress * 100).toInt()}%', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
           ],
         ),
         const SizedBox(height: 4),
         Text(isCalorie ? '$value' : '${value}g', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
         Text(isCalorie ? 'Kcal' : label, style: const TextStyle(fontSize: 10)),
       ],
     );
  }

  Widget _buildMealCard(BuildContext context, String title, Meal currentMeal,
      List<Meal> options, Function(Meal) onSelect) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  currentMeal.imagePath,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.black),
                    onPressed: () {
                       showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return SizedBox(
                            height: 450,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    l10n.selectFoodTitle,
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                ),
                                CarouselSlider(
                                  options: CarouselOptions(
                                    height: 350,
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
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black54, Colors.transparent],
                    ),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentMeal.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(currentMeal.description, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${currentMeal.calories} kcal', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        _buildMicroTag('P', '${currentMeal.protein}g', Colors.redAccent),
                        const SizedBox(width: 4),
                        _buildMicroTag('C', '${currentMeal.carbs}g', Colors.orangeAccent),
                        const SizedBox(width: 4),
                        _buildMicroTag('F', '${currentMeal.fat}g', Colors.yellow[800]!),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMicroTag(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCarouselItem(Meal meal) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                meal.imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    meal.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    meal.description,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const Spacer(),
                   Text(
                    '${meal.calories} kcal',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
