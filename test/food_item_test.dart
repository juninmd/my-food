import 'package:flutter_test/flutter_test.dart';
import 'package:my_food/models/food_item.dart';

void main() {
  group('FoodItem Tests', () {
    final foodItem = FoodItem(
      id: '123',
      name: 'Apple',
      description: 'A healthy fruit',
      calories: 95,
      protein: 0,
      carbs: 25,
      fat: 0,
      imageBase64: 'base64string',
    );

    test('toJson returns correct map', () {
      final json = foodItem.toJson();
      expect(json['id'], '123');
      expect(json['name'], 'Apple');
      expect(json['description'], 'A healthy fruit');
      expect(json['calories'], 95);
      expect(json['protein'], 0);
      expect(json['carbs'], 25);
      expect(json['fat'], 0);
      expect(json['imageBase64'], 'base64string');
    });

    test('fromJson creates correct object', () {
      final json = {
        'id': '456',
        'name': 'Banana',
        'description': 'Yellow fruit',
        'calories': 105,
        'protein': 1,
        'carbs': 27,
        'fat': 0,
        'imageBase64': null,
      };

      final newFoodItem = FoodItem.fromJson(json);
      expect(newFoodItem.id, '456');
      expect(newFoodItem.name, 'Banana');
      expect(newFoodItem.description, 'Yellow fruit');
      expect(newFoodItem.calories, 105);
      expect(newFoodItem.protein, 1);
      expect(newFoodItem.carbs, 27);
      expect(newFoodItem.fat, 0);
      expect(newFoodItem.imageBase64, null);
    });

    test('copyWith updates fields correctly', () {
      final updatedFoodItem = foodItem.copyWith(name: 'Green Apple', calories: 90);
      expect(updatedFoodItem.id, '123');
      expect(updatedFoodItem.name, 'Green Apple');
      expect(updatedFoodItem.description, 'A healthy fruit');
      expect(updatedFoodItem.calories, 90);
      expect(updatedFoodItem.protein, 0);
      expect(updatedFoodItem.carbs, 25);
      expect(updatedFoodItem.fat, 0);
      expect(updatedFoodItem.imageBase64, 'base64string');
    });
  });
}
