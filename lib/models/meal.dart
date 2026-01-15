import 'food_item.dart';

class Meal {
  final String id;
  final String name; // Breakfast, Lunch, Dinner
  FoodItem selectedFood;

  Meal({
    required this.id,
    required this.name,
    required this.selectedFood,
  });
}
