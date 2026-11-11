import 'package:flutter/material.dart';
import 'package:webdiet/data/meal_data.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/models/day_plan.dart';
import 'package:webdiet/models/meal.dart';
import 'package:webdiet/services/ai_recommendation_service.dart';
import 'package:webdiet/services/api_service.dart';
import 'package:webdiet/services/home_prefs.dart';
import 'package:webdiet/theme/app_motion.dart';
import 'package:webdiet/widgets/home_body.dart';
import 'package:webdiet/widgets/home_shell.dart';

class HomePage extends StatefulWidget {
  final ApiService? apiService;
  const HomePage({super.key, this.apiService});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final _prefs = HomePrefs();
  int _currentIndex = 0;
  int _water = 0;
  Map<MealSlot, int> _mealIndex = {for (final s in MealSlot.values) s: 0};
  Set<String> _checked = {};
  late Future<String> _quoteFuture;
  late ApiService _api;
  late final AnimationController _roll =
      AnimationController(vsync: this, duration: AppMotion.slot);

  @override
  void initState() {
    super.initState();
    _api = widget.apiService ?? ApiService();
    _quoteFuture = _api.fetchQuote();
    _load();
  }

  Future<void> _load() async {
    final s = await _prefs.load();
    if (!mounted) return;
    setState(() {
      _water = s.water;
      _mealIndex = s.mealIndex;
      _checked = s.checked;
    });
  }

  @override
  void dispose() {
    _roll.dispose();
    if (widget.apiService == null) _api.dispose();
    super.dispose();
  }

  Map<MealSlot, List<Meal>> _options(AppLocalizations l10n) => {
        MealSlot.breakfast: MealData.getBreakfastOptions(l10n),
        MealSlot.lunch: MealData.getLunchOptions(l10n),
        MealSlot.dinner: MealData.getDinnerOptions(l10n),
      };

  void _setMeal(MealSlot slot, int index) {
    setState(() => _mealIndex = {..._mealIndex, slot: index});
    _prefs.saveMeal(slot, index);
  }

  void _setWater(int glasses) {
    setState(() => _water = glasses);
    _prefs.saveWater(glasses);
  }

  void _setChecked(Set<String> checked) {
    setState(() => _checked = checked);
    _prefs.saveChecked(checked);
  }

  /// Spins the three meals like a slot machine, then lands on the
  /// combination closest to the calorie goal and brings a new quote.
  void _surpriseMe() {
    if (_roll.isAnimating) return;
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final best = AiRecommendationService().getBestMealCombination(l10n);
    final quote = _api.fetchQuote();
    setState(() => _currentIndex = 0);
    _roll.duration = AppMotion.of(context, AppMotion.slot);
    _roll.forward(from: 0).whenComplete(() {
      if (!mounted) return;
      for (var i = 0; i < MealSlot.values.length; i++) {
        _setMeal(MealSlot.values[i], best[i]);
      }
      setState(() {
        _quoteFuture = quote;
      });
      _roll.value = 0;
      messenger.showSnackBar(SnackBar(content: Text(l10n.surpriseMeFeedback)));
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final options = _options(l10n);
    final index = {
      for (final s in MealSlot.values)
        s: _mealIndex[s]! < options[s]!.length ? _mealIndex[s]! : 0,
    };
    final plan =
        DayPlan({for (final s in MealSlot.values) s: options[s]![index[s]!]});

    return HomeShell(
      currentIndex: _currentIndex,
      onTab: (i) => setState(() => _currentIndex = i),
      marketBadge: plan.remainingToBuy(_checked),
      child: HomeBody(
        key: ValueKey(_currentIndex),
        currentIndex: _currentIndex,
        plan: plan,
        options: options,
        mealIndex: index,
        water: _water,
        checked: _checked,
        quoteFuture: _quoteFuture,
        roll: _roll,
        onSurpriseMe: _surpriseMe,
        onRefreshQuote: () => setState(() => _quoteFuture = _api.fetchQuote()),
        onSetWater: _setWater,
        onSelectMeal: _setMeal,
        onCheckedChanged: _setChecked,
        onGoTo: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}
