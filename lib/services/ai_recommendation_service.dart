import 'dart:math';
import 'package:my_food/models/meal.dart';
import 'package:my_food/data/diet_constants.dart';

class AiRecommendationService {
  static List<int> getBestMealCombination(
      List<Meal> breakfasts, List<Meal> lunches, List<Meal> dinners, List<int> currentCombination) {
    int target = DietConstants.caloriesTarget;

    // Calculate all combinations and their difference from target
    List<Map<String, dynamic>> combinations = [];

    for (int b = 0; b < breakfasts.length; b++) {
      for (int l = 0; l < lunches.length; l++) {
        for (int d = 0; d < dinners.length; d++) {
          // Avoid the exact same combination if possible
          if (b == currentCombination[0] && l == currentCombination[1] && d == currentCombination[2]) {
             continue;
          }
          int totalCals =
              breakfasts[b].calories + lunches[l].calories + dinners[d].calories;
          int diff = (totalCals - target).abs();

          combinations.add({
            'diff': diff,
            'combo': [b, l, d],
          });
        }
      }
    }

    // Sort by diff
    combinations.sort((a, b) => (a['diff'] as int).compareTo(b['diff'] as int));

    // Take top 3 closest options and pick one randomly to ensure surprise
    int topN = min(3, combinations.length);
    if (topN == 0) return [0, 0, 0]; // Fallback

    final random = Random();
    int selectedIndex = random.nextInt(topN);

    return combinations[selectedIndex]['combo'] as List<int>;
  }
}
