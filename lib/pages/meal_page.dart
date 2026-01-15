import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../data/meal_data.dart';
import 'shopping_list_page.dart';

class MealPage extends StatefulWidget {
  const MealPage({Key? key}) : super(key: key);

  @override
  _MealPageState createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  late Meal _breakfast;
  late Meal _lunch;
  late Meal _dinner;

  @override
  void initState() {
    super.initState();
    _breakfast = MealData.breakfastOptions[0];
    _lunch = MealData.lunchOptions[0];
    _dinner = MealData.dinnerOptions[0];
  }

  void _surpriseMe() {
    setState(() {
      final random = Random();
      _breakfast = MealData.breakfastOptions[random.nextInt(MealData.breakfastOptions.length)];
      _lunch = MealData.lunchOptions[random.nextInt(MealData.lunchOptions.length)];
      _dinner = MealData.dinnerOptions[random.nextInt(MealData.dinnerOptions.length)];
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

    return Scaffold(
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
                  stretchModes: <StretchMode>[
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                  ],
                  background: Stack(fit: StackFit.expand, children: <Widget>[
                    Image.asset(
                      "assets/images/bg3.jpg",
                      fit: BoxFit.cover,
                      color: const Color(0xaa212121),
                      colorBlendMode: BlendMode.darken,
                    ),
                  ])),
            ),
          ];
        },
        body: Container(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 80),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Total Calorias: $totalCalories',
                  style: Theme.of(context).textTheme.headline6,
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _surpriseMe,
        icon: const Icon(Icons.auto_awesome),
        label: const Text('Me Surpreenda'),
      ),
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
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Image.asset(
                currentMeal.imagePath,
                height: 60,
                width: 60,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentMeal.name,
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${currentMeal.calories} calorias',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(currentMeal.description),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 400,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
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
            child: Text('Trocar Alimento'),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselItem(Meal meal) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 5.0),
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
          SizedBox(height: 8),
          Text(
            meal.name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              meal.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(height: 4),
          Text(
            '${meal.calories} calorias',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
