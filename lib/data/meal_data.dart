import 'package:my_food/l10n/generated/app_localizations.dart';
import '../models/meal.dart';

class MealData {
  static List<Meal> getBreakfastOptions(AppLocalizations l10n) {
    return [
      Meal(
        name: l10n.mealBreadWithEggName,
        imagePath: 'assets/images/lanche.jpg',
        calories: 300,
        protein: 15,
        carbs: 30,
        fat: 12,
        description: l10n.mealBreadWithEggDesc,
        ingredients: [
          l10n.ingWholeWheatBread,
          l10n.ingEggs,
          l10n.ingButter,
          l10n.ingSalt
        ],
      ),
      Meal(
        name: l10n.mealOatmealName,
        imagePath: 'assets/images/lanche.jpg',
        calories: 250,
        protein: 8,
        carbs: 45,
        fat: 5,
        description: l10n.mealOatmealDesc,
        ingredients: [
          l10n.ingOats,
          l10n.ingMilk,
          l10n.ingCinnamon,
          l10n.ingSugar
        ],
      ),
      Meal(
        name: l10n.mealFruitYogurtName,
        imagePath: 'assets/images/lanche.jpg',
        calories: 200,
        protein: 6,
        carbs: 40,
        fat: 2,
        description: l10n.mealFruitYogurtDesc,
        ingredients: [
          l10n.ingBanana,
          l10n.ingApple,
          l10n.ingNaturalYogurt,
          l10n.ingHoney
        ],
      ),
    ];
  }

  static List<Meal> getLunchOptions(AppLocalizations l10n) {
    return [
      Meal(
        name: l10n.mealChickenSweetPotatoName,
        imagePath: 'assets/images/lanche.jpg',
        calories: 500,
        protein: 40,
        carbs: 60,
        fat: 10,
        description: l10n.mealChickenSweetPotatoDesc,
        ingredients: [
          l10n.ingChickenBreast,
          l10n.ingSweetPotato,
          l10n.ingOliveOil,
          l10n.ingSalt
        ],
      ),
      Meal(
        name: l10n.mealCaesarSaladName,
        imagePath: 'assets/images/lanche.jpg',
        calories: 400,
        protein: 25,
        carbs: 15,
        fat: 25,
        description: l10n.mealCaesarSaladDesc,
        ingredients: [
          l10n.ingLettuce,
          l10n.ingCroutons,
          l10n.ingParmesanCheese,
          l10n.ingCaesarSauce,
          l10n.ingChicken
        ],
      ),
      Meal(
        name: l10n.mealGrilledFishName,
        imagePath: 'assets/images/lanche.jpg',
        calories: 450,
        protein: 35,
        carbs: 20,
        fat: 20,
        description: l10n.mealGrilledFishDesc,
        ingredients: [
          l10n.ingTilapia,
          l10n.ingBroccoli,
          l10n.ingCarrot,
          l10n.ingOliveOil
        ],
      ),
    ];
  }

  static List<Meal> getDinnerOptions(AppLocalizations l10n) {
    return [
      Meal(
        name: l10n.mealVegetableSoupName,
        imagePath: 'assets/images/lanche.jpg',
        calories: 250,
        protein: 5,
        carbs: 40,
        fat: 8,
        description: l10n.mealVegetableSoupDesc,
        ingredients: [
          l10n.ingPotato,
          l10n.ingCarrot,
          l10n.ingZucchini,
          l10n.ingOnion,
          l10n.ingGarlic
        ],
      ),
      Meal(
        name: l10n.mealCheeseOmeletName,
        imagePath: 'assets/images/lanche.jpg',
        calories: 350,
        protein: 20,
        carbs: 5,
        fat: 28,
        description: l10n.mealCheeseOmeletDesc,
        ingredients: [
          l10n.ingEggs,
          l10n.ingMinasCheese,
          l10n.ingOregano,
          l10n.ingSalt
        ],
      ),
      Meal(
        name: l10n.mealNaturalSandwichName,
        imagePath: 'assets/images/lanche.jpg',
        calories: 300,
        protein: 15,
        carbs: 35,
        fat: 10,
        description: l10n.mealNaturalSandwichDesc,
        ingredients: [
          l10n.ingSlicedBread,
          l10n.ingTuna,
          l10n.ingMayonnaise,
          l10n.ingLettuce
        ],
      ),
    ];
  }
}
