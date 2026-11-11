import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:webdiet/data/diet_constants.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/models/day_plan.dart';
import 'package:webdiet/models/meal.dart';
import 'package:webdiet/utils/day_clock.dart';
import 'package:webdiet/widgets/common/view_header.dart';
import 'package:webdiet/widgets/today/day_line.dart';
import 'package:webdiet/widgets/today/meal_sheet.dart';
import 'package:webdiet/widgets/today/meal_swap_sheet.dart';
import 'package:webdiet/widgets/today/orbit_card.dart';
import 'package:webdiet/widgets/today/quote_card.dart';
import 'package:webdiet/widgets/today/surprise_button.dart';
import 'package:webdiet/widgets/today/water_card.dart';

/// The Today tab: orbit, water, quote, Surprise Me and the day line.
class DashboardView extends StatelessWidget {
  final DayPlan plan;
  final Map<MealSlot, List<Meal>> options;
  final Map<MealSlot, int> mealIndex;
  final int water;
  final Future<String> quoteFuture;
  final Animation<double> roll;
  final VoidCallback onSurpriseMe;
  final VoidCallback onRefreshQuote;
  final ValueChanged<int> onSetWater;
  final void Function(MealSlot slot, int index) onSelectMeal;

  const DashboardView({
    super.key,
    required this.plan,
    required this.options,
    required this.mealIndex,
    required this.water,
    required this.quoteFuture,
    required this.roll,
    required this.onSurpriseMe,
    required this.onRefreshQuote,
    required this.onSetWater,
    required this.onSelectMeal,
  });

  void _openMeal(BuildContext context, MealSlot slot) {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    MealSheet.show(context, slot: slot, meal: plan[slot], onSwap: () {
      MealSwapSheet.show(context,
          slot: slot,
          options: options[slot]!,
          current: mealIndex[slot]!, onSelect: (i) {
        onSelectMeal(slot, i);
        messenger.showSnackBar(SnackBar(
            content: Text(l10n.mealSwapped(
                slotLabel(l10n, slot), options[slot]![i].name))));
      });
    });
  }

  String _greeting(AppLocalizations l10n, DateTime now) =>
      switch (DayClock.period(now)) {
        DayPart.morning => l10n.goodMorning,
        DayPart.afternoon => l10n.goodAfternoon,
        DayPart.evening => l10n.goodEvening,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final locale = Localizations.localeOf(context).toLanguageTag();
    final date = DateFormat.MMMMEEEEd(locale).format(now);
    final wide = MediaQuery.sizeOf(context).width > 900;

    final stats =
        Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      OrbitCard(plan: plan),
      const SizedBox(height: 14),
      IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(
            child: WaterCard(
              glasses: water,
              target: DietConstants.waterGlassTarget,
              onSet: onSetWater,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
              child: QuoteCard(
                  quoteFuture: quoteFuture, onRefresh: onRefreshQuote)),
        ]),
      ),
      const SizedBox(height: 14),
      SurpriseButton(roll: roll, onTap: onSurpriseMe),
    ]);
    final day =
        Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SectionTitle(title: l10n.dayLineTitle, hint: l10n.tapToOpen),
      DayLine(
        plan: plan,
        options: options,
        mealIndex: mealIndex,
        roll: roll,
        onOpen: (slot) => _openMeal(context, slot),
      ),
    ]);

    return PageFrame(slivers: [
      SliverToBoxAdapter(
        child: ViewHeader(overline: date, title: _greeting(l10n, now)),
      ),
      SliverToBoxAdapter(
        child: wide
            ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(child: stats),
                const SizedBox(width: 24),
                Expanded(child: day),
              ])
            : Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                stats,
                const SizedBox(height: 10),
                day,
              ]),
      ),
    ]);
  }
}
