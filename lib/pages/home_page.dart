import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';
import 'package:my_food/services/api_service.dart';
import 'package:my_food/services/ai_recommendation_service.dart';
import 'package:my_food/widgets/surprise_me_dialog.dart';
import 'package:my_food/widgets/home_navigation.dart';
import 'package:my_food/widgets/home_body.dart';

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final body = HomeBody(
      currentIndex: _currentIndex,
      breakfastIndex: _breakfastIndex,
      lunchIndex: _lunchIndex,
      dinnerIndex: _dinnerIndex,
      waterGlasses: _waterGlasses,
      quoteFuture: _quoteFuture,
      onSurpriseMe: _surpriseMe,
      onUpdateWater: (val) {
        setState(() => _waterGlasses = val);
        _saveState('water_glasses', val);
      },
      onUpdateBreakfast: (val) {
        setState(() => _breakfastIndex = val);
        _saveState('breakfast_index', val);
      },
      onUpdateLunch: (val) {
        setState(() => _lunchIndex = val);
        _saveState('lunch_index', val);
      },
      onUpdateDinner: (val) {
        setState(() => _dinnerIndex = val);
        _saveState('dinner_index', val);
      },
      onUpdateIndex: (val) => setState(() => _currentIndex = val),
    );
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
