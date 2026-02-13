// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'My Food';

  @override
  String get bmiTitle => 'BMI Calculator';

  @override
  String get bmiCalculateTitle => 'Calculate your Body Mass Index';

  @override
  String get bmiWeightLabel => 'Weight (kg)';

  @override
  String get bmiHeightLabel => 'Height (cm)';

  @override
  String get bmiCalculateButton => 'CALCULATE';

  @override
  String get bmiResultLabel => 'Your BMI is:';

  @override
  String get bmiErrorInvalidInput => 'Please enter valid values.';

  @override
  String get bmiUnderweight => 'Underweight';

  @override
  String get bmiNormal => 'Normal weight';

  @override
  String get bmiOverweight => 'Overweight';

  @override
  String get bmiObesity => 'Obesity';

  @override
  String get shoppingListTitle => 'Shopping List';

  @override
  String get shoppingListClipboardTitle => 'Shopping List:';

  @override
  String get shoppingListCopied => 'List copied to clipboard!';

  @override
  String get shoppingListCopyTooltip => 'Copy list';

  @override
  String get randomRecipeTitle => 'Surprise Recipe';

  @override
  String get randomRecipeRetry => 'Try Again';

  @override
  String get randomRecipeErrorPrefix => 'Error: ';

  @override
  String get randomRecipeNoName => 'No name';

  @override
  String get randomRecipeCategoryPrefix => 'Category: ';

  @override
  String get randomRecipeNA => 'N/A';

  @override
  String get randomRecipeInstructions => 'Instructions:';

  @override
  String get randomRecipeNoInstructions => 'No instructions available.';

  @override
  String get randomRecipeNew => 'New Recipe';

  @override
  String get randomRecipeNoData => 'No data found.';

  @override
  String get mealBreadWithEggName => 'Bread with Egg';

  @override
  String get mealBreadWithEggDesc => 'Whole wheat bread with scrambled eggs.';

  @override
  String get mealOatmealName => 'Oatmeal';

  @override
  String get mealOatmealDesc => 'Oats cooked with milk and cinnamon.';

  @override
  String get mealFruitYogurtName => 'Fruit with Yogurt';

  @override
  String get mealFruitYogurtDesc => 'Fruit salad with natural yogurt.';

  @override
  String get mealChickenSweetPotatoName => 'Chicken with Sweet Potato';

  @override
  String get mealChickenSweetPotatoDesc =>
      'Grilled chicken breast with mashed sweet potato.';

  @override
  String get mealCaesarSaladName => 'Caesar Salad';

  @override
  String get mealCaesarSaladDesc => 'Lettuce, croutons and special sauce.';

  @override
  String get mealGrilledFishName => 'Grilled Fish';

  @override
  String get mealGrilledFishDesc => 'Tilapia fillet with vegetables.';

  @override
  String get mealVegetableSoupName => 'Vegetable Soup';

  @override
  String get mealVegetableSoupDesc =>
      'Light soup with a variety of vegetables.';

  @override
  String get mealCheeseOmeletName => 'Cheese Omelet';

  @override
  String get mealCheeseOmeletDesc => 'Omelet stuffed with minas cheese.';

  @override
  String get mealNaturalSandwichName => 'Natural Sandwich';

  @override
  String get mealNaturalSandwichDesc => 'Sliced bread with tuna pate.';

  @override
  String get ingWholeWheatBread => 'Whole wheat bread';

  @override
  String get ingEggs => 'Eggs';

  @override
  String get ingButter => 'Butter';

  @override
  String get ingSalt => 'Salt';

  @override
  String get ingOats => 'Oats';

  @override
  String get ingMilk => 'Milk';

  @override
  String get ingCinnamon => 'Cinnamon';

  @override
  String get ingSugar => 'Sugar';

  @override
  String get ingBanana => 'Banana';

  @override
  String get ingApple => 'Apple';

  @override
  String get ingNaturalYogurt => 'Natural Yogurt';

  @override
  String get ingHoney => 'Honey';

  @override
  String get ingChickenBreast => 'Chicken breast';

  @override
  String get ingSweetPotato => 'Sweet potato';

  @override
  String get ingOliveOil => 'Olive oil';

  @override
  String get ingLettuce => 'Lettuce';

  @override
  String get ingCroutons => 'Croutons';

  @override
  String get ingParmesanCheese => 'Parmesan cheese';

  @override
  String get ingCaesarSauce => 'Caesar sauce';

  @override
  String get ingChicken => 'Chicken';

  @override
  String get ingTilapia => 'Tilapia';

  @override
  String get ingBroccoli => 'Broccoli';

  @override
  String get ingCarrot => 'Carrot';

  @override
  String get ingPotato => 'Potato';

  @override
  String get ingZucchini => 'Zucchini';

  @override
  String get ingOnion => 'Onion';

  @override
  String get ingGarlic => 'Garlic';

  @override
  String get ingMinasCheese => 'Minas cheese';

  @override
  String get ingOregano => 'Oregano';

  @override
  String get ingSlicedBread => 'Sliced bread';

  @override
  String get ingTuna => 'Tuna';

  @override
  String get ingMayonnaise => 'Mayonnaise';

  @override
  String get mealPageTitle => 'Diet';

  @override
  String get menuTitle => 'Menu';

  @override
  String get dailyHydration => 'Daily Hydration';

  @override
  String hydrationStatus(int glasses, int target) {
    return '$glasses / $target glasses (250ml)';
  }

  @override
  String totalCalories(int calories) {
    return 'Total Calories: $calories';
  }

  @override
  String get macroProtein => 'Protein';

  @override
  String get macroCarbs => 'Carbs';

  @override
  String get macroFat => 'Fats';

  @override
  String get mealBreakfast => 'Breakfast';

  @override
  String get mealLunch => 'Lunch';

  @override
  String get mealDinner => 'Dinner';

  @override
  String get surpriseMeButton => 'Surprise Me';

  @override
  String get changeFoodButton => 'Change Food';

  @override
  String get selectFoodTitle => 'Select a food:';

  @override
  String get quoteErrorMessage => 'Failed to load quote.';

  @override
  String get quoteFallbackMessage => 'Keep focused and healthy!';

  @override
  String get recipeLoadError => 'Failed to load recipe.';

  @override
  String get connectionError => 'Connection error.';

  @override
  String get surpriseMeFeedback =>
      'Meal plan randomized! Check out the new quote.';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get toolsTitle => 'Tools';

  @override
  String get hello => 'Hello!';

  @override
  String get caloriesLeft => 'Calories Left';

  @override
  String get waterTrackerTitle => 'Water Intake';

  @override
  String get addWater => 'Add 250ml';

  @override
  String get editMeal => 'Edit Meal';

  @override
  String get dailyGoal => 'Daily Goal';

  @override
  String get consumed => 'Consumed';

  @override
  String get remaining => 'Remaining';
}
