import 'package:flutter/material.dart';
import 'package:webdiet/models/meal.dart';

class ModernMealCardImage extends StatelessWidget {
  final Meal meal;
  final String title;

  const ModernMealCardImage({
    super.key,
    required this.meal,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'meal_${title}_${meal.name}',
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          image: DecorationImage(
            image: AssetImage(meal.imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
