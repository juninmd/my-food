import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_food/models/food.dart';

class FoodService {
  static const String _storageKey = 'food_catalog';

  Future<List<Food>> getFoods() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_storageKey);

    if (jsonString == null) {
      // Return empty list if no custom foods are saved yet
      return [];
    }

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => Food.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveFood(Food food) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Food> currentFoods = await getFoods();

    // Check if food already exists (edit mode)
    final existingIndex = currentFoods.indexWhere((f) => f.id == food.id);
    if (existingIndex >= 0) {
      currentFoods[existingIndex] = food;
    } else {
      currentFoods.add(food);
    }

    final String jsonString = jsonEncode(currentFoods.map((f) => f.toJson()).toList());
    await prefs.setString(_storageKey, jsonString);
  }

  Future<void> deleteFood(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Food> currentFoods = await getFoods();

    currentFoods.removeWhere((f) => f.id == id);

    final String jsonString = jsonEncode(currentFoods.map((f) => f.toJson()).toList());
    await prefs.setString(_storageKey, jsonString);
  }
}
