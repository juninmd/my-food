import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/food_item.dart';
import '../models/meal.dart';

class DietData extends ChangeNotifier {
  List<Meal> _meals = [];
  List<FoodItem> _availableFoods = [];

  List<Meal> get meals => _meals;
  List<FoodItem> get availableFoods => _availableFoods;

  DietData() {
    _initData();
  }

  void _initData() {
    // Mock Data
    _availableFoods = [
      FoodItem(
        id: '1',
        name: 'Omelete de Legumes',
        description: 'Ovos mexidos com espinafre e tomate',
        imageAsset: 'assets/images/lanche.jpg',
        calories: 250,
        protein: 20,
        carbs: 5,
        fat: 18,
        ingredients: ['2 Ovos', 'Espinafre', 'Tomate', 'Azeite'],
      ),
      FoodItem(
        id: '2',
        name: 'Frango Grelhado com Salada',
        description: 'Peito de frango com mix de folhas',
        imageAsset: 'assets/images/lanche.jpg',
        calories: 350,
        protein: 40,
        carbs: 10,
        fat: 15,
        ingredients: ['Peito de Frango', 'Alface', 'Rúcula', 'Limão'],
      ),
      FoodItem(
        id: '3',
        name: 'Peixe com Legumes',
        description: 'Filé de tilápia com brócolis',
        imageAsset: 'assets/images/lanche.jpg',
        calories: 300,
        protein: 35,
        carbs: 12,
        fat: 10,
        ingredients: ['Filé de Tilápia', 'Brócolis', 'Cenoura'],
      ),
      FoodItem(
        id: '4',
        name: 'Iogurte com Frutas',
        description: 'Iogurte natural com morango e granola',
        imageAsset: 'assets/images/lanche.jpg',
        calories: 200,
        protein: 8,
        carbs: 30,
        fat: 5,
        ingredients: ['Iogurte Natural', 'Morango', 'Granola'],
      ),
       FoodItem(
        id: '5',
        name: 'Sanduíche Natural',
        description: 'Pão integral com atum e cenoura',
        imageAsset: 'assets/images/lanche.jpg',
        calories: 320,
        protein: 15,
        carbs: 45,
        fat: 8,
        ingredients: ['Pão Integral', 'Atum', 'Cenoura', 'Maionese Light'],
      ),
    ];

    _meals = [
      Meal(id: 'm1', name: 'Café da Manhã', selectedFood: _availableFoods[0]),
      Meal(id: 'm2', name: 'Almoço', selectedFood: _availableFoods[1]),
      Meal(id: 'm3', name: 'Jantar', selectedFood: _availableFoods[2]),
    ];
  }

  void swapFood(Meal meal, FoodItem newFood) {
    meal.selectedFood = newFood;
    notifyListeners();
  }

  void surpriseMe() {
    final random = Random();
    for (var meal in _meals) {
      meal.selectedFood = _availableFoods[random.nextInt(_availableFoods.length)];
    }
    notifyListeners();
  }

  int get totalCalories => _meals.fold(0, (sum, meal) => sum + meal.selectedFood.calories);
  int get totalProtein => _meals.fold(0, (sum, meal) => sum + meal.selectedFood.protein);
  int get totalCarbs => _meals.fold(0, (sum, meal) => sum + meal.selectedFood.carbs);
  int get totalFat => _meals.fold(0, (sum, meal) => sum + meal.selectedFood.fat);

  Map<String, int> get shoppingList {
    Map<String, int> list = {};
    for (var meal in _meals) {
      for (var ingredient in meal.selectedFood.ingredients) {
        if (list.containsKey(ingredient)) {
          list[ingredient] = list[ingredient]! + 1;
        } else {
          list[ingredient] = 1;
        }
      }
    }
    return list;
  }
}
