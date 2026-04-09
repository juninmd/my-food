import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_food/models/food_item.dart';
import 'package:my_food/services/food_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('FoodService Tests', () {
    final foodService = FoodService();
    final testFood = FoodItem(
      id: '1',
      name: 'Test Food',
      description: 'Test Description',
      calories: 100,
      protein: 10,
      carbs: 20,
      fat: 5,
    );

    test('getFoods returns empty list initially', () async {
      final foods = await foodService.getFoods();
      expect(foods, isEmpty);
    });

    test('saveFood saves a new food item', () async {
      await foodService.saveFood(testFood);
      final foods = await foodService.getFoods();
      expect(foods.length, 1);
      expect(foods.first.id, '1');
      expect(foods.first.name, 'Test Food');
    });

    test('saveFood updates an existing food item', () async {
      await foodService.saveFood(testFood);

      final updatedFood = testFood.copyWith(name: 'Updated Food');
      await foodService.saveFood(updatedFood);

      final foods = await foodService.getFoods();
      expect(foods.length, 1);
      expect(foods.first.name, 'Updated Food');
    });

    test('deleteFood removes a food item', () async {
      await foodService.saveFood(testFood);
      var foods = await foodService.getFoods();
      expect(foods.length, 1);

      await foodService.deleteFood('1');
      foods = await foodService.getFoods();
      expect(foods, isEmpty);
    });
  });
}
