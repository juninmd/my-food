import 'dart:math';
import 'package:my_food/l10n/generated/app_localizations.dart';
import 'package:my_food/models/meal.dart';
import 'package:my_food/data/meal_data.dart';
import 'package:my_food/data/diet_constants.dart';

class AiRecommendationService {
  List<int> getBestMealCombination(AppLocalizations l10n) {
    final breakfastOptions = MealData.getBreakfastOptions(l10n);
    final lunchOptions = MealData.getLunchOptions(l10n);
    final dinnerOptions = MealData.getDinnerOptions(l10n);

    int target = DietConstants.caloriesTarget;
    int bestDiff = 999999;
    List<int> bestCombination = [0, 0, 0];

    for (int b = 0; b < breakfastOptions.length; b++) {
      for (int l = 0; l < lunchOptions.length; l++) {
        for (int d = 0; d < dinnerOptions.length; d++) {
          int totalCal = breakfastOptions[b].calories +
              lunchOptions[l].calories +
              dinnerOptions[d].calories;
          int diff = (target - totalCal).abs();

          if (diff < bestDiff) {
            bestDiff = diff;
            bestCombination = [b, l, d];
          } else if (diff == bestDiff) {
            if (Random().nextBool()) {
               bestCombination = [b, l, d];
            }
          }
        }
      }
    }

    return bestCombination;
  }
}
