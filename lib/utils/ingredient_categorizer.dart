import 'package:my_food/l10n/generated/app_localizations.dart';

class IngredientCategorizer {
  static String getCategory(String ingredient, AppLocalizations l10n) {
    // Map of ingredient name to category name
    // We check against the localized string value

    // Dairy & Eggs
    if (ingredient == l10n.ingEggs ||
        ingredient == l10n.ingButter ||
        ingredient == l10n.ingMilk ||
        ingredient == l10n.ingNaturalYogurt ||
        ingredient == l10n.ingParmesanCheese ||
        ingredient == l10n.ingMinasCheese) {
      return l10n.catDairyEggs;
    }

    // Fruits & Vegetables
    if (ingredient == l10n.ingBanana ||
        ingredient == l10n.ingApple ||
        ingredient == l10n.ingSweetPotato ||
        ingredient == l10n.ingLettuce ||
        ingredient == l10n.ingBroccoli ||
        ingredient == l10n.ingCarrot ||
        ingredient == l10n.ingPotato ||
        ingredient == l10n.ingZucchini ||
        ingredient == l10n.ingOnion ||
        ingredient == l10n.ingGarlic) {
      return l10n.catFruitsVegetables;
    }

    // Meat & Poultry
    if (ingredient == l10n.ingChickenBreast ||
        ingredient == l10n.ingChicken ||
        ingredient == l10n.ingTilapia ||
        ingredient == l10n.ingTuna) {
      return l10n.catMeatPoultry;
    }

    // Grains
    if (ingredient == l10n.ingWholeWheatBread ||
        ingredient == l10n.ingOats ||
        ingredient == l10n.ingCroutons ||
        ingredient == l10n.ingSlicedBread) {
      return l10n.catGrains;
    }

    // Pantry (everything else essentially, but let's be specific)
    if (ingredient == l10n.ingSalt ||
        ingredient == l10n.ingCinnamon ||
        ingredient == l10n.ingSugar ||
        ingredient == l10n.ingHoney ||
        ingredient == l10n.ingOliveOil ||
        ingredient == l10n.ingCaesarSauce ||
        ingredient == l10n.ingOregano ||
        ingredient == l10n.ingMayonnaise) {
      return l10n.catPantry;
    }

    return l10n.catOther;
  }
}
