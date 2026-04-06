import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/food_item.dart';

class FoodService {
  static const String _storageKey = 'custom_foods';

  Future<List<FoodItem>> getFoods() async {
    final prefs = await SharedPreferences.getInstance();
    final String? foodsJson = prefs.getString(_storageKey);

    if (foodsJson == null) {
      return [];
    }

    try {
      final List<dynamic> decodedList = json.decode(foodsJson);
      return decodedList.map((item) => FoodItem.fromJson(item)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveFood(FoodItem food) async {
    final foods = await getFoods();
    final existingIndex = foods.indexWhere((f) => f.id == food.id);

    if (existingIndex >= 0) {
      foods[existingIndex] = food;
    } else {
      foods.add(food);
    }

    await _saveFoodsList(foods);
  }

  Future<void> deleteFood(String id) async {
    final foods = await getFoods();
    foods.removeWhere((f) => f.id == id);
    await _saveFoodsList(foods);
  }

  Future<void> _saveFoodsList(List<FoodItem> foods) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedList =
        json.encode(foods.map((f) => f.toJson()).toList());
    await prefs.setString(_storageKey, encodedList);
  }
}
