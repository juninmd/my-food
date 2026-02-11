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
    Size size = MediaQuery.of(context).size;

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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Text(
                l10n.menuTitle,
                style: const TextStyle(
                  color: Colors.white,
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
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              pinned: true,
              stretch: true,
              toolbarHeight: size.height * 0.1,
              collapsedHeight: size.height * 0.1,
              expandedHeight: size.height * 0.2,
              title: Text(
                l10n.mealPageTitle,
                style: const TextStyle(color: Colors.white),
              ),
              centerTitle: true,
              backgroundColor: Colors.black,
              actions: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () => _openShoppingList(breakfast, lunch, dinner),
                  tooltip: l10n.shoppingListTitle,
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const <StretchMode>[
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                  ],
                  background: Stack(fit: StackFit.expand, children: <Widget>[
                    Image.asset(
                      "assets/images/lanche.jpg",
                      fit: BoxFit.cover,
                      color: const Color(0xaa212121),
                      colorBlendMode: BlendMode.darken,
                    ),
                  ])),
            ),
          ];
        },
        body: ListView(
          padding: const EdgeInsets.only(bottom: 80),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<String>(
                    future: _quoteFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      if (snapshot.hasData) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue.shade100),
                          ),
                          child: Text(
                            snapshot.data!,
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.blueAccent,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue.shade100),
                          ),
                          child: Text(
                            l10n.quoteFallbackMessage,
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.blueAccent,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  Text(
                    l10n.dailyHydration,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          if (_waterGlasses > 0) {
                            setState(() {
                              _waterGlasses--;
                              _saveWater();
                            });
                          }
                        },
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              l10n.hydrationStatus(
                                  _waterGlasses, _targetGlasses),
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: _waterGlasses / _targetGlasses,
                              backgroundColor: Colors.blue[100],
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.blue),
                              minHeight: 10,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () {
                          setState(() {
                            _waterGlasses++;
                            _saveWater();
                          });
                        },
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  Text(
                    l10n.totalCalories(totalCalories),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildMacroBar(l10n.macroProtein, totalProtein,
                      DietConstants.proteinTarget, Colors.redAccent),
                  const SizedBox(height: 8),
                  _buildMacroBar(l10n.macroCarbs, totalCarbs,
                      DietConstants.carbsTarget, Colors.orangeAccent),
                  const SizedBox(height: 8),
                  _buildMacroBar(l10n.macroFat, totalFat,
                      DietConstants.fatTarget, Colors.yellow[800]!),
                ],
              ),
            ),
            _buildMealSection(
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
            _buildMealSection(
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
            _buildMealSection(
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _surpriseMe,
        icon: const Icon(Icons.auto_awesome),
        label: Text(l10n.surpriseMeButton),
      ),
    );
  }

  Widget _buildMacroBar(String label, int value, int target, Color color) {
    double progress = value / target;
    if (progress > 1.0) progress = 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('${value}g / ${target}g'),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            // ignore: deprecated_member_use
            backgroundColor: color.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildMealSection(BuildContext context, String title, Meal currentMeal,
      List<Meal> options, Function(Meal) onSelect) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Image.asset(
                currentMeal.imagePath,
                height: 60,
                width: 60,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentMeal.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${currentMeal.calories} kcal | P: ${currentMeal.protein}g C: ${currentMeal.carbs}g G: ${currentMeal.fat}g',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(currentMeal.description),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    height: 400,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            l10n.selectFoodTitle,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 300,
                            autoPlay: false,
                            enlargeCenterPage: true,
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
            child: Text(l10n.changeFoodButton),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselItem(Meal meal) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Image.asset(
              meal.imagePath,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            meal.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              meal.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${meal.calories} kcal | P: ${meal.protein}g C: ${meal.carbs}g G: ${meal.fat}g',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
