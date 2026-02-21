import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'My Food'**
  String get appTitle;

  /// No description provided for @bmiTitle.
  ///
  /// In en, this message translates to:
  /// **'BMI Calculator'**
  String get bmiTitle;

  /// No description provided for @bmiCalculateTitle.
  ///
  /// In en, this message translates to:
  /// **'Calculate your Body Mass Index'**
  String get bmiCalculateTitle;

  /// No description provided for @bmiWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get bmiWeightLabel;

  /// No description provided for @bmiHeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get bmiHeightLabel;

  /// No description provided for @bmiCalculateButton.
  ///
  /// In en, this message translates to:
  /// **'CALCULATE'**
  String get bmiCalculateButton;

  /// No description provided for @bmiResultLabel.
  ///
  /// In en, this message translates to:
  /// **'Your BMI is:'**
  String get bmiResultLabel;

  /// No description provided for @bmiErrorInvalidInput.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid values.'**
  String get bmiErrorInvalidInput;

  /// No description provided for @bmiUnderweight.
  ///
  /// In en, this message translates to:
  /// **'Underweight'**
  String get bmiUnderweight;

  /// No description provided for @bmiNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal weight'**
  String get bmiNormal;

  /// No description provided for @bmiOverweight.
  ///
  /// In en, this message translates to:
  /// **'Overweight'**
  String get bmiOverweight;

  /// No description provided for @bmiObesity.
  ///
  /// In en, this message translates to:
  /// **'Obesity'**
  String get bmiObesity;

  /// No description provided for @shoppingListTitle.
  ///
  /// In en, this message translates to:
  /// **'Shopping List'**
  String get shoppingListTitle;

  /// No description provided for @shoppingListClipboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Shopping List:'**
  String get shoppingListClipboardTitle;

  /// No description provided for @shoppingListCopied.
  ///
  /// In en, this message translates to:
  /// **'List copied to clipboard!'**
  String get shoppingListCopied;

  /// No description provided for @shoppingListCopyTooltip.
  ///
  /// In en, this message translates to:
  /// **'Copy list'**
  String get shoppingListCopyTooltip;

  /// No description provided for @randomRecipeTitle.
  ///
  /// In en, this message translates to:
  /// **'Surprise Recipe'**
  String get randomRecipeTitle;

  /// No description provided for @randomRecipeRetry.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get randomRecipeRetry;

  /// No description provided for @randomRecipeErrorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: '**
  String get randomRecipeErrorPrefix;

  /// No description provided for @randomRecipeNoName.
  ///
  /// In en, this message translates to:
  /// **'No name'**
  String get randomRecipeNoName;

  /// No description provided for @randomRecipeCategoryPrefix.
  ///
  /// In en, this message translates to:
  /// **'Category: '**
  String get randomRecipeCategoryPrefix;

  /// No description provided for @randomRecipeNA.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get randomRecipeNA;

  /// No description provided for @randomRecipeInstructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions:'**
  String get randomRecipeInstructions;

  /// No description provided for @randomRecipeNoInstructions.
  ///
  /// In en, this message translates to:
  /// **'No instructions available.'**
  String get randomRecipeNoInstructions;

  /// No description provided for @randomRecipeNew.
  ///
  /// In en, this message translates to:
  /// **'New Recipe'**
  String get randomRecipeNew;

  /// No description provided for @randomRecipeNoData.
  ///
  /// In en, this message translates to:
  /// **'No data found.'**
  String get randomRecipeNoData;

  /// No description provided for @mealBreadWithEggName.
  ///
  /// In en, this message translates to:
  /// **'Bread with Egg'**
  String get mealBreadWithEggName;

  /// No description provided for @mealBreadWithEggDesc.
  ///
  /// In en, this message translates to:
  /// **'Whole wheat bread with scrambled eggs.'**
  String get mealBreadWithEggDesc;

  /// No description provided for @mealOatmealName.
  ///
  /// In en, this message translates to:
  /// **'Oatmeal'**
  String get mealOatmealName;

  /// No description provided for @mealOatmealDesc.
  ///
  /// In en, this message translates to:
  /// **'Oats cooked with milk and cinnamon.'**
  String get mealOatmealDesc;

  /// No description provided for @mealFruitYogurtName.
  ///
  /// In en, this message translates to:
  /// **'Fruit with Yogurt'**
  String get mealFruitYogurtName;

  /// No description provided for @mealFruitYogurtDesc.
  ///
  /// In en, this message translates to:
  /// **'Fruit salad with natural yogurt.'**
  String get mealFruitYogurtDesc;

  /// No description provided for @mealChickenSweetPotatoName.
  ///
  /// In en, this message translates to:
  /// **'Chicken with Sweet Potato'**
  String get mealChickenSweetPotatoName;

  /// No description provided for @mealChickenSweetPotatoDesc.
  ///
  /// In en, this message translates to:
  /// **'Grilled chicken breast with mashed sweet potato.'**
  String get mealChickenSweetPotatoDesc;

  /// No description provided for @mealCaesarSaladName.
  ///
  /// In en, this message translates to:
  /// **'Caesar Salad'**
  String get mealCaesarSaladName;

  /// No description provided for @mealCaesarSaladDesc.
  ///
  /// In en, this message translates to:
  /// **'Lettuce, croutons and special sauce.'**
  String get mealCaesarSaladDesc;

  /// No description provided for @mealGrilledFishName.
  ///
  /// In en, this message translates to:
  /// **'Grilled Fish'**
  String get mealGrilledFishName;

  /// No description provided for @mealGrilledFishDesc.
  ///
  /// In en, this message translates to:
  /// **'Tilapia fillet with vegetables.'**
  String get mealGrilledFishDesc;

  /// No description provided for @mealVegetableSoupName.
  ///
  /// In en, this message translates to:
  /// **'Vegetable Soup'**
  String get mealVegetableSoupName;

  /// No description provided for @mealVegetableSoupDesc.
  ///
  /// In en, this message translates to:
  /// **'Light soup with a variety of vegetables.'**
  String get mealVegetableSoupDesc;

  /// No description provided for @mealCheeseOmeletName.
  ///
  /// In en, this message translates to:
  /// **'Cheese Omelet'**
  String get mealCheeseOmeletName;

  /// No description provided for @mealCheeseOmeletDesc.
  ///
  /// In en, this message translates to:
  /// **'Omelet stuffed with minas cheese.'**
  String get mealCheeseOmeletDesc;

  /// No description provided for @mealNaturalSandwichName.
  ///
  /// In en, this message translates to:
  /// **'Natural Sandwich'**
  String get mealNaturalSandwichName;

  /// No description provided for @mealNaturalSandwichDesc.
  ///
  /// In en, this message translates to:
  /// **'Sliced bread with tuna pate.'**
  String get mealNaturalSandwichDesc;

  /// No description provided for @ingWholeWheatBread.
  ///
  /// In en, this message translates to:
  /// **'Whole wheat bread'**
  String get ingWholeWheatBread;

  /// No description provided for @ingEggs.
  ///
  /// In en, this message translates to:
  /// **'Eggs'**
  String get ingEggs;

  /// No description provided for @ingButter.
  ///
  /// In en, this message translates to:
  /// **'Butter'**
  String get ingButter;

  /// No description provided for @ingSalt.
  ///
  /// In en, this message translates to:
  /// **'Salt'**
  String get ingSalt;

  /// No description provided for @ingOats.
  ///
  /// In en, this message translates to:
  /// **'Oats'**
  String get ingOats;

  /// No description provided for @ingMilk.
  ///
  /// In en, this message translates to:
  /// **'Milk'**
  String get ingMilk;

  /// No description provided for @ingCinnamon.
  ///
  /// In en, this message translates to:
  /// **'Cinnamon'**
  String get ingCinnamon;

  /// No description provided for @ingSugar.
  ///
  /// In en, this message translates to:
  /// **'Sugar'**
  String get ingSugar;

  /// No description provided for @ingBanana.
  ///
  /// In en, this message translates to:
  /// **'Banana'**
  String get ingBanana;

  /// No description provided for @ingApple.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get ingApple;

  /// No description provided for @ingNaturalYogurt.
  ///
  /// In en, this message translates to:
  /// **'Natural Yogurt'**
  String get ingNaturalYogurt;

  /// No description provided for @ingHoney.
  ///
  /// In en, this message translates to:
  /// **'Honey'**
  String get ingHoney;

  /// No description provided for @ingChickenBreast.
  ///
  /// In en, this message translates to:
  /// **'Chicken breast'**
  String get ingChickenBreast;

  /// No description provided for @ingSweetPotato.
  ///
  /// In en, this message translates to:
  /// **'Sweet potato'**
  String get ingSweetPotato;

  /// No description provided for @ingOliveOil.
  ///
  /// In en, this message translates to:
  /// **'Olive oil'**
  String get ingOliveOil;

  /// No description provided for @ingLettuce.
  ///
  /// In en, this message translates to:
  /// **'Lettuce'**
  String get ingLettuce;

  /// No description provided for @ingCroutons.
  ///
  /// In en, this message translates to:
  /// **'Croutons'**
  String get ingCroutons;

  /// No description provided for @ingParmesanCheese.
  ///
  /// In en, this message translates to:
  /// **'Parmesan cheese'**
  String get ingParmesanCheese;

  /// No description provided for @ingCaesarSauce.
  ///
  /// In en, this message translates to:
  /// **'Caesar sauce'**
  String get ingCaesarSauce;

  /// No description provided for @ingChicken.
  ///
  /// In en, this message translates to:
  /// **'Chicken'**
  String get ingChicken;

  /// No description provided for @ingTilapia.
  ///
  /// In en, this message translates to:
  /// **'Tilapia'**
  String get ingTilapia;

  /// No description provided for @ingBroccoli.
  ///
  /// In en, this message translates to:
  /// **'Broccoli'**
  String get ingBroccoli;

  /// No description provided for @ingCarrot.
  ///
  /// In en, this message translates to:
  /// **'Carrot'**
  String get ingCarrot;

  /// No description provided for @ingPotato.
  ///
  /// In en, this message translates to:
  /// **'Potato'**
  String get ingPotato;

  /// No description provided for @ingZucchini.
  ///
  /// In en, this message translates to:
  /// **'Zucchini'**
  String get ingZucchini;

  /// No description provided for @ingOnion.
  ///
  /// In en, this message translates to:
  /// **'Onion'**
  String get ingOnion;

  /// No description provided for @ingGarlic.
  ///
  /// In en, this message translates to:
  /// **'Garlic'**
  String get ingGarlic;

  /// No description provided for @ingMinasCheese.
  ///
  /// In en, this message translates to:
  /// **'Minas cheese'**
  String get ingMinasCheese;

  /// No description provided for @ingOregano.
  ///
  /// In en, this message translates to:
  /// **'Oregano'**
  String get ingOregano;

  /// No description provided for @ingSlicedBread.
  ///
  /// In en, this message translates to:
  /// **'Sliced bread'**
  String get ingSlicedBread;

  /// No description provided for @ingTuna.
  ///
  /// In en, this message translates to:
  /// **'Tuna'**
  String get ingTuna;

  /// No description provided for @ingMayonnaise.
  ///
  /// In en, this message translates to:
  /// **'Mayonnaise'**
  String get ingMayonnaise;

  /// No description provided for @mealPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Diet'**
  String get mealPageTitle;

  /// No description provided for @menuTitle.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menuTitle;

  /// No description provided for @dailyHydration.
  ///
  /// In en, this message translates to:
  /// **'Daily Hydration'**
  String get dailyHydration;

  /// No description provided for @hydrationStatus.
  ///
  /// In en, this message translates to:
  /// **'{glasses} / {target} glasses (250ml)'**
  String hydrationStatus(int glasses, int target);

  /// No description provided for @totalCalories.
  ///
  /// In en, this message translates to:
  /// **'Total Calories: {calories}'**
  String totalCalories(int calories);

  /// No description provided for @macroProtein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get macroProtein;

  /// No description provided for @macroCarbs.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get macroCarbs;

  /// No description provided for @macroFat.
  ///
  /// In en, this message translates to:
  /// **'Fats'**
  String get macroFat;

  /// No description provided for @mealBreakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get mealBreakfast;

  /// No description provided for @mealLunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get mealLunch;

  /// No description provided for @mealDinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get mealDinner;

  /// No description provided for @surpriseMeButton.
  ///
  /// In en, this message translates to:
  /// **'Surprise Me'**
  String get surpriseMeButton;

  /// No description provided for @changeFoodButton.
  ///
  /// In en, this message translates to:
  /// **'Change Food'**
  String get changeFoodButton;

  /// No description provided for @selectFoodTitle.
  ///
  /// In en, this message translates to:
  /// **'Select a food:'**
  String get selectFoodTitle;

  /// No description provided for @quoteErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to load quote.'**
  String get quoteErrorMessage;

  /// No description provided for @quoteFallbackMessage.
  ///
  /// In en, this message translates to:
  /// **'Keep focused and healthy!'**
  String get quoteFallbackMessage;

  /// No description provided for @recipeLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load recipe.'**
  String get recipeLoadError;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection error.'**
  String get connectionError;

  /// No description provided for @surpriseMeFeedback.
  ///
  /// In en, this message translates to:
  /// **'Meal plan randomized! Check out the new quote.'**
  String get surpriseMeFeedback;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @toolsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get toolsTitle;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello!'**
  String get hello;

  /// No description provided for @caloriesLeft.
  ///
  /// In en, this message translates to:
  /// **'Calories Left'**
  String get caloriesLeft;

  /// No description provided for @waterTrackerTitle.
  ///
  /// In en, this message translates to:
  /// **'Water Intake'**
  String get waterTrackerTitle;

  /// No description provided for @addWater.
  ///
  /// In en, this message translates to:
  /// **'Add 250ml'**
  String get addWater;

  /// No description provided for @editMeal.
  ///
  /// In en, this message translates to:
  /// **'Edit Meal'**
  String get editMeal;

  /// No description provided for @dailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily Goal'**
  String get dailyGoal;

  /// No description provided for @consumed.
  ///
  /// In en, this message translates to:
  /// **'Consumed'**
  String get consumed;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @nutritionistNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Nutritionist\'s Note'**
  String get nutritionistNoteTitle;

  /// No description provided for @nutritionistNoteBody.
  ///
  /// In en, this message translates to:
  /// **'Remember to drink water before every meal and keep your protein intake high today!'**
  String get nutritionistNoteBody;

  /// No description provided for @planStatus.
  ///
  /// In en, this message translates to:
  /// **'Plan Status'**
  String get planStatus;

  /// No description provided for @approvedBy.
  ///
  /// In en, this message translates to:
  /// **'Approved by Dr. Smith'**
  String get approvedBy;

  /// No description provided for @yourProgress.
  ///
  /// In en, this message translates to:
  /// **'Your Progress'**
  String get yourProgress;

  /// No description provided for @swapMeal.
  ///
  /// In en, this message translates to:
  /// **'Swap Meal'**
  String get swapMeal;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
