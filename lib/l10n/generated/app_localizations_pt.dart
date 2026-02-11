// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'My Food';

  @override
  String get bmiTitle => 'Calculadora IMC';

  @override
  String get bmiCalculateTitle => 'Calcule seu Índice de Massa Corporal';

  @override
  String get bmiWeightLabel => 'Peso (kg)';

  @override
  String get bmiHeightLabel => 'Altura (cm)';

  @override
  String get bmiCalculateButton => 'CALCULAR';

  @override
  String get bmiResultLabel => 'Seu IMC é:';

  @override
  String get bmiErrorInvalidInput => 'Por favor, insira valores válidos.';

  @override
  String get bmiUnderweight => 'Abaixo do peso';

  @override
  String get bmiNormal => 'Peso normal';

  @override
  String get bmiOverweight => 'Sobrepeso';

  @override
  String get bmiObesity => 'Obesidade';

  @override
  String get shoppingListTitle => 'Lista de Compras';

  @override
  String get shoppingListClipboardTitle => 'Lista de Compras:';

  @override
  String get shoppingListCopied =>
      'Lista copiada para a área de transferência!';

  @override
  String get shoppingListCopyTooltip => 'Copiar lista';

  @override
  String get randomRecipeTitle => 'Receita Surpresa';

  @override
  String get randomRecipeRetry => 'Tentar Novamente';

  @override
  String get randomRecipeErrorPrefix => 'Erro: ';

  @override
  String get randomRecipeNoName => 'Sem nome';

  @override
  String get randomRecipeCategoryPrefix => 'Categoria: ';

  @override
  String get randomRecipeNA => 'N/A';

  @override
  String get randomRecipeInstructions => 'Instruções:';

  @override
  String get randomRecipeNoInstructions => 'Sem instruções disponíveis.';

  @override
  String get randomRecipeNew => 'Nova Receita';

  @override
  String get randomRecipeNoData => 'Nenhum dado encontrado.';

  @override
  String get mealBreadWithEggName => 'Pão com Ovo';

  @override
  String get mealBreadWithEggDesc => 'Pão integral com ovos mexidos.';

  @override
  String get mealOatmealName => 'Mingau de Aveia';

  @override
  String get mealOatmealDesc => 'Aveia cozida com leite e canela.';

  @override
  String get mealFruitYogurtName => 'Frutas com Iogurte';

  @override
  String get mealFruitYogurtDesc => 'Salada de frutas com iogurte natural.';

  @override
  String get mealChickenSweetPotatoName => 'Frango com Batata Doce';

  @override
  String get mealChickenSweetPotatoDesc =>
      'Peito de frango grelhado com purê de batata doce.';

  @override
  String get mealCaesarSaladName => 'Salada Ceasar';

  @override
  String get mealCaesarSaladDesc => 'Alface, croutons e molho especial.';

  @override
  String get mealGrilledFishName => 'Peixe Grelhado';

  @override
  String get mealGrilledFishDesc => 'Filé de tilápia com legumes.';

  @override
  String get mealVegetableSoupName => 'Sopa de Legumes';

  @override
  String get mealVegetableSoupDesc => 'Sopa leve com variedade de legumes.';

  @override
  String get mealCheeseOmeletName => 'Omelete de Queijo';

  @override
  String get mealCheeseOmeletDesc => 'Omelete recheado com queijo minas.';

  @override
  String get mealNaturalSandwichName => 'Sanduíche Natural';

  @override
  String get mealNaturalSandwichDesc => 'Pão de forma com patê de atum.';

  @override
  String get ingWholeWheatBread => 'Pão integral';

  @override
  String get ingEggs => 'Ovos';

  @override
  String get ingButter => 'Manteiga';

  @override
  String get ingSalt => 'Sal';

  @override
  String get ingOats => 'Aveia';

  @override
  String get ingMilk => 'Leite';

  @override
  String get ingCinnamon => 'Canela';

  @override
  String get ingSugar => 'Açúcar';

  @override
  String get ingBanana => 'Banana';

  @override
  String get ingApple => 'Maçã';

  @override
  String get ingNaturalYogurt => 'Iogurte Natural';

  @override
  String get ingHoney => 'Mel';

  @override
  String get ingChickenBreast => 'Peito de frango';

  @override
  String get ingSweetPotato => 'Batata doce';

  @override
  String get ingOliveOil => 'Azeite';

  @override
  String get ingLettuce => 'Alface';

  @override
  String get ingCroutons => 'Croutons';

  @override
  String get ingParmesanCheese => 'Queijo parmesão';

  @override
  String get ingCaesarSauce => 'Molho Caesar';

  @override
  String get ingChicken => 'Frango';

  @override
  String get ingTilapia => 'Tilápia';

  @override
  String get ingBroccoli => 'Brócolis';

  @override
  String get ingCarrot => 'Cenoura';

  @override
  String get ingPotato => 'Batata';

  @override
  String get ingZucchini => 'Abobrinha';

  @override
  String get ingOnion => 'Cebola';

  @override
  String get ingGarlic => 'Alho';

  @override
  String get ingMinasCheese => 'Queijo minas';

  @override
  String get ingOregano => 'Orégano';

  @override
  String get ingSlicedBread => 'Pão de forma';

  @override
  String get ingTuna => 'Atum';

  @override
  String get ingMayonnaise => 'Maionese';

  @override
  String get mealPageTitle => 'Alimentação';

  @override
  String get menuTitle => 'Menu';

  @override
  String get dailyHydration => 'Hidratação Diária';

  @override
  String hydrationStatus(int glasses, int target) {
    return '$glasses / $target copos (250ml)';
  }

  @override
  String totalCalories(int calories) {
    return 'Total Calorias: $calories';
  }

  @override
  String get macroProtein => 'Proteínas';

  @override
  String get macroCarbs => 'Carboidratos';

  @override
  String get macroFat => 'Gorduras';

  @override
  String get mealBreakfast => 'Café da manhã';

  @override
  String get mealLunch => 'Almoço';

  @override
  String get mealDinner => 'Jantar';

  @override
  String get surpriseMeButton => 'Me Surpreenda';

  @override
  String get changeFoodButton => 'Trocar Alimento';

  @override
  String get selectFoodTitle => 'Selecione um alimento:';

  @override
  String get quoteErrorMessage => 'Falha ao carregar frase.';

  @override
  String get quoteFallbackMessage => 'Mantenha-se focado e saudável!';

  @override
  String get recipeLoadError => 'Falha ao carregar receita.';

  @override
  String get connectionError => 'Erro de conexão.';

  @override
  String get surpriseMeFeedback =>
      'Plano alimentar alterado! Confira a nova frase.';
}
