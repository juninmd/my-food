import 'package:flutter/material.dart';
import 'package:webdiet/data/diet_constants.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/models/day_plan.dart';
import 'package:webdiet/theme/app_motion.dart';
import 'package:webdiet/theme/app_tokens.dart';
import 'package:webdiet/theme/app_type.dart';
import 'package:webdiet/utils/nutrition_math.dart';
import 'package:webdiet/widgets/today/orbit_ring.dart';

/// "How am I doing today?" in one look: calories on the outer ring,
/// protein, carbs and fat inside, exact numbers on the side.
class OrbitCard extends StatelessWidget {
  final DayPlan plan;

  const OrbitCard({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final l10n = AppLocalizations.of(context)!;
    final kcalShare =
        NutritionMath.progress(plan.calories, DietConstants.caloriesTarget);
    final left = (DietConstants.caloriesTarget - plan.calories).clamp(0, 99999);
    final rows = [
      (
        l10n.caloriesTitle,
        plan.calories,
        DietConstants.caloriesTarget,
        '',
        t.mint
      ),
      (
        l10n.macroProtein,
        plan.protein,
        DietConstants.proteinTarget,
        'g',
        t.protein
      ),
      (l10n.macroCarbs, plan.carbs, DietConstants.carbsTarget, 'g', t.carbs),
      (l10n.macroFat, plan.fat, DietConstants.fatTarget, 'g', t.fat),
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: t.card(),
      child: Column(children: [
        Row(children: [
          OrbitRing(
            size: 140,
            track: t.sunk,
            colors: [for (final r in rows) r.$5],
            values: [
              for (final r in rows) NutritionMath.progress(r.$2, r.$3),
            ],
            center: Column(mainAxisSize: MainAxisSize.min, children: [
              _CountUp(
                value: (kcalShare * 100).round(),
                suffix: '%',
                style: AppType.display(20, color: t.ink),
              ),
              Text(l10n.ofGoal, style: TextStyle(fontSize: 10, color: t.ink2)),
            ]),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(children: [
              for (final r in rows)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          color: r.$5, borderRadius: BorderRadius.circular(3)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(r.$1,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13, color: t.ink)),
                    ),
                    _CountUp(
                        value: r.$2, style: AppType.data(12, color: t.ink)),
                    Text('/${r.$3}${r.$4}',
                        style: AppType.data(11,
                            color: t.ink2, weight: FontWeight.w500)),
                  ]),
                ),
            ]),
          ),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Text(l10n.todaysPlan, style: TextStyle(fontSize: 12, color: t.ink2)),
          const Spacer(),
          Text(l10n.kcalLeft('$left'),
              style: AppType.data(12, color: t.ink2, weight: FontWeight.w500)),
        ]),
      ]),
    );
  }
}

/// Number that counts from its previous value to the new one.
class _CountUp extends StatelessWidget {
  final int value;
  final String suffix;
  final TextStyle style;

  const _CountUp({required this.value, required this.style, this.suffix = ''});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: value),
      duration: AppMotion.of(context, const Duration(milliseconds: 1100)),
      curve: AppMotion.decel,
      builder: (context, v, _) => Text('$v$suffix', style: style),
    );
  }
}
