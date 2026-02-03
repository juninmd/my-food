import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
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
  late Meal _breakfast;
  late Meal _lunch;
  late Meal _dinner;
  int _waterGlasses = 0;
  final int _targetGlasses = DietConstants.waterGlassTarget;
  late Future<String> _quoteFuture;
  late ApiService _apiService;

  @override
  void initState() {
    super.initState();
    _apiService = widget.apiService ?? ApiService();
    _breakfast = MealData.breakfastOptions[0];
    _lunch = MealData.lunchOptions[0];
    _dinner = MealData.dinnerOptions[0];
    _quoteFuture = _apiService.fetchQuote();
  }

  @override
  void dispose() {
    if (widget.apiService == null) {
      _apiService.dispose();
    }
    super.dispose();
  }

  void _surpriseMe() {
    setState(() {
      final random = Random();
      _breakfast = MealData.breakfastOptions[random.nextInt(MealData.breakfastOptions.length)];
      _lunch = MealData.lunchOptions[random.nextInt(MealData.lunchOptions.length)];
      _dinner = MealData.dinnerOptions[random.nextInt(MealData.dinnerOptions.length)];
      _quoteFuture = _apiService.fetchQuote();
    });
  }

  void _openShoppingList() {
    List<String> allIngredients = [];
    allIngredients.addAll(_breakfast.ingredients);
    allIngredients.addAll(_lunch.ingredients);
    allIngredients.addAll(_dinner.ingredients);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShoppingListPage(ingredients: allIngredients),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    int totalCalories = _breakfast.calories + _lunch.calories + _dinner.calories;
    int totalProtein = _breakfast.protein + _lunch.protein + _dinner.protein;
    int totalCarbs = _breakfast.carbs + _lunch.carbs + _dinner.carbs;
    int totalFat = _breakfast.fat + _lunch.fat + _dinner.fat;

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calculate),
              title: const Text('Calculadora IMC'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BMICalculatorPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.restaurant_menu),
              title: const Text('Receita Surpresa'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RandomRecipePage()),
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
              title: const Text(
                "Alimentação",
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
              backgroundColor: Colors.black,
              actions: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: _openShoppingList,
                  tooltip: 'Lista de Compras',
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
                        return const SizedBox.shrink();
                      },
                    ),
                    Text(
                      'Hidratação Diária',
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
                              });
                            }
                          },
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                '$_waterGlasses / $_targetGlasses copos (250ml)',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              LinearProgressIndicator(
                                value: _waterGlasses / _targetGlasses,
                                backgroundColor: Colors.blue[100],
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
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
                            });
                          },
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    Text(
                      'Total Calorias: $totalCalories',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    _buildMacroBar('Proteínas', totalProtein, DietConstants.proteinTarget, Colors.redAccent),
                    const SizedBox(height: 8),
                    _buildMacroBar('Carboidratos', totalCarbs, DietConstants.carbsTarget, Colors.orangeAccent),
                    const SizedBox(height: 8),
                    _buildMacroBar('Gorduras', totalFat, DietConstants.fatTarget, Colors.yellow[800]!),
                  ],
                ),
              ),
              _buildMealSection(
                context,
                'Café da manhã',
                _breakfast,
                MealData.breakfastOptions,
                (meal) => setState(() => _breakfast = meal),
              ),
              _buildMealSection(
                context,
                'Almoço',
                _lunch,
                MealData.lunchOptions,
                (meal) => setState(() => _lunch = meal),
              ),
              _buildMealSection(
                context,
                'Jantar',
                _dinner,
                MealData.dinnerOptions,
                (meal) => setState(() => _dinner = meal),
              ),
            ],
          ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _surpriseMe,
        icon: const Icon(Icons.auto_awesome),
        label: const Text('Me Surpreenda'),
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
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildMealSection(
      BuildContext context, String title, Meal currentMeal, List<Meal> options, Function(Meal) onSelect) {
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
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
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
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Selecione um alimento:',
                            style: TextStyle(
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
            child: const Text('Trocar Alimento'),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0)
      ),
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
