import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webdiet/models/food_item.dart';
import 'package:webdiet/services/food_service.dart';

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

    test('getFoods skips a malformed entry and keeps the valid ones', () async {
      SharedPreferences.setMockInitialValues({
        'custom_foods':
            '[{"id":"1","name":"Ok","description":"d","calories":1,"protein":1,"carbs":1,"fat":1},'
                '{"id":"2","name":null},"not-a-map"]',
      });
      final foods = await foodService.getFoods();
      expect(foods.map((f) => f.id), ['1']);
    });

    test('saveFood keeps valid foods when another stored entry is malformed',
        () async {
      SharedPreferences.setMockInitialValues({
        'custom_foods':
            '[{"id":"1","name":"Ok","description":"d","calories":1,"protein":1,"carbs":1,"fat":1},{"id":"2"}]',
      });
      await foodService.saveFood(testFood.copyWith(id: '3'));
      final foods = await foodService.getFoods();
      expect(foods.map((f) => f.id), ['1', '3']);
    });

    test('saveFood writes back a stored entry it cannot parse', () async {
      SharedPreferences.setMockInitialValues({
        'custom_foods':
            '[{"id":"1","name":"Ok","description":"d","calories":1,"protein":1,"carbs":1,"fat":1},{"id":"2"}]',
      });
      await foodService.saveFood(testFood.copyWith(id: '3'));
      final prefs = await SharedPreferences.getInstance();
      final stored = json.decode(prefs.getString('custom_foods')!) as List;
      expect(stored.map((e) => e['id']), ['1', '2', '3']);
    });

    test('saveFood backs up a corrupt payload before overwriting it', () async {
      const corrupt = '[{"id":"1","name":"Ok"';
      SharedPreferences.setMockInitialValues({'custom_foods': corrupt});
      await foodService.saveFood(testFood);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('custom_foods_backup'), corrupt);
      expect((await foodService.getFoods()).map((f) => f.id), ['1']);
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
