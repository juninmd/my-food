import 'package:flutter/material.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/models/day_plan.dart';
import 'package:webdiet/models/meal.dart';
import 'package:webdiet/theme/app_motion.dart';
import 'package:webdiet/theme/app_tokens.dart';
import 'package:webdiet/utils/day_clock.dart';
import 'package:webdiet/widgets/common/cascade_in.dart';
import 'package:webdiet/widgets/today/day_line_tile.dart';

String slotLabel(AppLocalizations l10n, MealSlot slot) => switch (slot) {
      MealSlot.breakfast => l10n.mealBreakfast,
      MealSlot.lunch => l10n.mealLunch,
      MealSlot.dinner => l10n.mealDinner,
    };

/// The day's meals on a vertical line. Each dot shows whether the meal is
/// done, next or later by the clock. While [roll] runs, names spin like a
/// slot machine.
class DayLine extends StatelessWidget {
  final DayPlan plan;
  final Map<MealSlot, List<Meal>> options;
  final Map<MealSlot, int> mealIndex;
  final Animation<double> roll;
  final ValueChanged<MealSlot> onOpen;
  final DateTime? now;

  const DayLine({
    super.key,
    required this.plan,
    required this.options,
    required this.mealIndex,
    required this.roll,
    required this.onOpen,
    this.now,
  });

  Meal _shown(MealSlot slot, int tick) {
    if (tick < 0) return plan[slot];
    final list = options[slot]!;
    return list[(mealIndex[slot]! + tick + slot.index) % list.length];
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final status = DayClock.statuses(now ?? DateTime.now());

    return AnimatedBuilder(
      animation: roll,
      builder: (context, _) {
        final rolling = roll.value > 0 && roll.value < 1;
        final tick = rolling ? (roll.value * AppMotion.slotTicks).floor() : -1;
        return Stack(children: [
          Positioned(
            left: 6,
            top: 20,
            bottom: 20,
            child: Container(
              width: 2,
              decoration: BoxDecoration(
                color: t.line,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Column(children: [
            for (final slot in MealSlot.values)
              CascadeIn(
                index: slot.index,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: DayLineTile(
                    slot: slot,
                    meal: _shown(slot, tick),
                    status: status[slot]!,
                    rolling: rolling,
                    onTap: () => onOpen(slot),
                  ),
                ),
              ),
          ]),
        ]);
      },
    );
  }
}
