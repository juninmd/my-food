class FoodItem {
  final String id;
  final String name;
  final String description;
  final String imageAsset;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final List<String> ingredients;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.imageAsset,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.ingredients,
  });
}
