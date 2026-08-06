import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';
import 'package:my_food/data/meal_data.dart';
import 'package:my_food/data/diet_constants.dart';
import 'package:my_food/services/api_service.dart';
import 'package:my_food/services/ai_recommendation_service.dart';
import 'package:my_food/widgets/dashboard_view.dart';
import 'package:my_food/widgets/shopping_list_view.dart';
import 'package:my_food/widgets/surprise_me_dialog.dart';
import 'package:my_food/widgets/tools_view.dart';
import 'package:my_food/widgets/meal_selector_sheet.dart';
import 'package:my_food/pages/food_catalog_page.dart';
import 'package:my_food/widgets/home_navigation.dart';

class HomePage extends StatefulWidget {
  final ApiService? apiService;
  const HomePage({super.key, this.apiService});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  int _breakfastIndex = 0;
  int _lunchIndex = 0;
  int _dinnerIndex = 0;
  int _waterGlasses = 0;
  late Future<String> _quoteFuture;
  late ApiService _apiService;

  @override
  void initState() {
    super.initState();
    _apiService = widget.apiService ?? ApiService();
    _quoteFuture = _apiService.fetchQuote();
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _waterGlasses = prefs.getInt('water_glasses') ?? 0;
      _breakfastIndex = prefs.getInt('breakfast_index') ?? 0;
      _lunchIndex = prefs.getInt('lunch_index') ?? 0;
      _dinnerIndex = prefs.getInt('dinner_index') ?? 0;
    });
  }

  Future<void> _saveState(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  @override
  void dispose() {
    if (widget.apiService == null) _apiService.dispose();
    super.dispose();
  }

  void _surpriseMe() async {
    final l10n = AppLocalizations.of(context)!;
    final bestCombination = AiRecommendationService().getBestMealCombination(l10n);
    final quoteFuture = _apiService.fetchQuote();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SurpriseMeDialog(
        quoteFuture: quoteFuture,
        onReveal: () {
          if (!mounted) return;
          setState(() {
            _breakfastIndex = bestCombination[0];
            _lunchIndex = bestCombination[1];
            _dinnerIndex = bestCombination[2];
            _saveState('breakfast_index', _breakfastIndex);
            _saveState('lunch_index', _lunchIndex);
            _saveState('dinner_index', _dinnerIndex);
            _quoteFuture = quoteFuture;
          });
        },
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    final breakfastOptions = MealData.getBreakfastOptions(l10n);
    final lunchOptions = MealData.getLunchOptions(l10n);
    final dinnerOptions = MealData.getDinnerOptions(l10n);

    if (_breakfastIndex >= breakfastOptions.length) _breakfastIndex = 0;
    if (_lunchIndex >= lunchOptions.length) _lunchIndex = 0;
    if (_dinnerIndex >= dinnerOptions.length) _dinnerIndex = 0;

    switch (_currentIndex) {
      case 0:
        return DashboardView(
          quoteFuture: _quoteFuture,
          breakfast: breakfastOptions[_breakfastIndex],
          lunch: lunchOptions[_lunchIndex],
          dinner: dinnerOptions[_dinnerIndex],
          waterGlasses: _waterGlasses,
          onAddWater: () => setState(() {
            if (_waterGlasses < DietConstants.waterGlassTarget + 5) {
              _waterGlasses++;
              _saveState('water_glasses', _waterGlasses);
            }
          }),
          onEditBreakfast: (_) => MealSelectorSheet.show(context, breakfastOptions, (selected) {
            setState(() {
              _breakfastIndex = breakfastOptions.indexOf(selected);
              _saveState('breakfast_index', _breakfastIndex);
            });
          }),
          onEditLunch: (_) => MealSelectorSheet.show(context, lunchOptions, (selected) {
            setState(() {
              _lunchIndex = lunchOptions.indexOf(selected);
              _saveState('lunch_index', _lunchIndex);
            });
          }),
          onEditDinner: (_) => MealSelectorSheet.show(context, dinnerOptions, (selected) {
            setState(() {
              _dinnerIndex = dinnerOptions.indexOf(selected);
              _saveState('dinner_index', _dinnerIndex);
            });
          }),
          onSurpriseMe: _surpriseMe,
        );
      case 1:
        return ShoppingListView(
          ingredients: [
            ...breakfastOptions[_breakfastIndex].ingredients,
            ...lunchOptions[_lunchIndex].ingredients,
            ...dinnerOptions[_dinnerIndex].ingredients,
          ],
        );
      case 2:
        return const FoodCatalogPage();
      case 3:
        return ToolsView(onSurpriseMe: () {
          _surpriseMe();
          setState(() => _currentIndex = 0);
        });
      default: return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final body = _buildBody(l10n);
    void onTap(int i) => setState(() => _currentIndex = i);

    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          return Row(
            children: [
              HomeNavigation.buildDesktopRail(context, _currentIndex, onTap, l10n),
              const VerticalDivider(thickness: 1, width: 1),
              Expanded(child: SafeArea(child: body)),
            ],
          );
        }
        return SafeArea(child: body);
      }),
      bottomNavigationBar: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > 800) return const SizedBox.shrink();
        return HomeNavigation.buildBottomBar(context, _currentIndex, onTap, l10n);
      }),
    );
  }
}
