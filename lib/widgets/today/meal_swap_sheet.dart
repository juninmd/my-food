import 'package:flutter/material.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/models/day_plan.dart';
import 'package:webdiet/models/meal.dart';
import 'package:webdiet/theme/app_tokens.dart';
import 'package:webdiet/theme/app_type.dart';
import 'package:webdiet/widgets/common/cascade_in.dart';
import 'package:webdiet/widgets/common/macro_tiles.dart';
import 'package:webdiet/widgets/common/meal_plate.dart';
import 'package:webdiet/widgets/common/pressable.dart';
import 'package:webdiet/widgets/today/day_line.dart';

/// Carousel of the options for one meal, each showing how many kcal it
/// adds or removes compared with the current choice.
class MealSwapSheet extends StatelessWidget {
  final MealSlot slot;
  final List<Meal> options;
  final int current;
  final ValueChanged<int> onSelect;

  const MealSwapSheet({
    super.key,
    required this.slot,
    required this.options,
    required this.current,
    required this.onSelect,
  });

  static Future<void> show(BuildContext context,
      {required MealSlot slot,
      required List<Meal> options,
      required int current,
      required ValueChanged<int> onSelect}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => MealSwapSheet(
          slot: slot, options: options, current: current, onSelect: onSelect),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final l10n = AppLocalizations.of(context)!;
    final width = (MediaQuery.sizeOf(context).width * 0.66).clamp(200.0, 300.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(slotLabel(l10n, slot).toUpperCase(), style: AppType.label(t.ink2)),
        const SizedBox(height: 6),
        Text(l10n.chooseAnotherOption,
            style: AppType.display(24, color: t.ink)),
        const SizedBox(height: 4),
        Text(l10n.swipeToChoose, style: TextStyle(color: t.ink2)),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            itemCount: options.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final m = options[i];
              final delta = m.calories - options[current].calories;
              final isCurrent = i == current;
              return CascadeIn(
                index: i,
                child: Pressable(
                  onTap: () {
                    Navigator.pop(context);
                    onSelect(i);
                  },
                  child: Container(
                    width: width,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: t.surface,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                          color: isCurrent ? t.mint : t.line, width: 2),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MealPlate(
                              protein: m.protein,
                              carbs: m.carbs,
                              fat: m.fat,
                              size: 64),
                          const Spacer(),
                          Text(m.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppType.display(16, color: t.ink)),
                          const SizedBox(height: 4),
                          Text(
                              macroLine(
                                  l10n, m.calories, m.protein, m.carbs, m.fat),
                              style: AppType.data(11,
                                  color: t.ink2, weight: FontWeight.w500)),
                          const SizedBox(height: 6),
                          Text(
                            isCurrent
                                ? l10n.currentLabel
                                : '${delta > 0 ? '+' : ''}$delta kcal',
                            style: AppType.data(12,
                                color: isCurrent
                                    ? t.mint
                                    : (delta > 0 ? t.protein : t.mint)),
                          ),
                        ]),
                  ),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}
