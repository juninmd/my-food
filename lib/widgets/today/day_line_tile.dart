import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/models/day_plan.dart';
import 'package:webdiet/models/meal.dart';
import 'package:webdiet/theme/app_tokens.dart';
import 'package:webdiet/theme/app_type.dart';
import 'package:webdiet/utils/day_clock.dart';
import 'package:webdiet/widgets/common/macro_tiles.dart';
import 'package:webdiet/widgets/common/meal_plate.dart';
import 'package:webdiet/widgets/common/pressable.dart';
import 'package:webdiet/widgets/today/day_line.dart';

/// One meal on the day line: status dot, composition plate, name and macros.
class DayLineTile extends StatelessWidget {
  final MealSlot slot;
  final Meal meal;
  final SlotStatus status;
  final bool rolling;
  final VoidCallback onTap;

  const DayLineTile({
    super.key,
    required this.slot,
    required this.meal,
    required this.status,
    required this.rolling,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final l10n = AppLocalizations.of(context)!;
    final chip = switch (status) {
      SlotStatus.next => l10n.statusNext,
      SlotStatus.done => l10n.statusDone,
      SlotStatus.later => null,
    };

    return Row(children: [
      Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: status == SlotStatus.done ? t.mint : t.surface,
          border: Border.all(
            color: status == SlotStatus.later ? t.line : t.mint,
            width: 2,
          ),
          boxShadow: status == SlotStatus.next
              ? [
                  BoxShadow(
                      color: t.mint.withValues(alpha: 0.35), blurRadius: 10)
                ]
              : null,
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Pressable(
          onTap: onTap,
          semanticLabel: '${slotLabel(l10n, slot)}: ${meal.name}',
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: t.card(radius: 22),
            child: Row(children: [
              MealPlate(
                protein: meal.protein,
                carbs: meal.carbs,
                fat: meal.fat,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Flexible(
                        child: Text(
                          '${slot.time} · ${slotLabel(l10n, slot).toUpperCase()}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppType.label(t.ink2),
                        ),
                      ),
                      if (chip != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: t.mintSoft,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child:
                              Text(chip, style: AppType.data(9, color: t.mint)),
                        ),
                      ],
                    ]),
                    const SizedBox(height: 4),
                    ImageFiltered(
                      enabled: rolling,
                      imageFilter: ImageFilter.blur(sigmaY: 1.6),
                      child: Text(
                        meal.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppType.display(16, color: t.ink),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      macroLine(l10n, meal.calories, meal.protein, meal.carbs,
                          meal.fat),
                      style: AppType.data(11,
                          color: t.ink2, weight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: t.ink2),
            ]),
          ),
        ),
      ),
    ]);
  }
}
