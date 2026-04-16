class Meal {
  final String name;
  final String imagePath;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final String description;
  final List<String> ingredients;
  final String? imageBase64;

  const Meal({
    required this.name,
    required this.imagePath,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.description,
    required this.ingredients,
    this.imageBase64,
  });
}
