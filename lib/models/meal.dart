class Meal {
  final String name;
  final String imagePath;
  final int calories;
  final String description;
  final List<String> ingredients;

  const Meal({
    required this.name,
    required this.imagePath,
    required this.calories,
    required this.description,
    required this.ingredients,
  });
}
