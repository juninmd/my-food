import 'package:flutter/material.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/theme/app_motion.dart';
import 'package:webdiet/theme/app_tokens.dart';
import 'package:webdiet/theme/app_type.dart';
import 'package:webdiet/widgets/common/pressable.dart';
import 'package:webdiet/widgets/today/live_glass.dart';

/// Hydration card: a live glass, one dot per glass (tap a dot to correct
/// the count) and a button that adds 250 ml.
class WaterCard extends StatelessWidget {
  /// Glasses above the goal that can still be logged.
  static const extraGlasses = 5;

  final int glasses;
  final int target;
  final ValueChanged<int> onSet;

  const WaterCard({
    super.key,
    required this.glasses,
    required this.target,
    required this.onSet,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final l10n = AppLocalizations.of(context)!;
    final reached = glasses >= target;
    final dur = AppMotion.of(context, AppMotion.tick);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: t.card(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(l10n.waterTrackerTitle.toUpperCase(),
            style: AppType.label(t.ink2)),
        const SizedBox(height: 10),
        Center(
          child: LiveGlass(
            level: glasses / target,
            water: t.water,
            rim: Color.lerp(t.water, t.line, 0.5)!,
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Wrap(spacing: 4, runSpacing: 4, children: [
            for (var i = 1; i <= target; i++)
              Semantics(
                button: true,
                label: '$i',
                child: GestureDetector(
                  onTap: () => onSet(i == glasses ? i - 1 : i),
                  child: AnimatedContainer(
                    duration: dur,
                    curve: AppMotion.springCurve,
                    width: i <= glasses ? 13 : 11,
                    height: i <= glasses ? 13 : 11,
                    decoration: BoxDecoration(
                      color: i <= glasses ? t.water : t.sunk,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
          ]),
        ),
        const SizedBox(height: 4),
        Center(
          child: Text(
            l10n.hydrationStatus(glasses, target),
            style: AppType.data(10, color: t.ink2, weight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 10),
        Pressable(
          onTap:
              glasses < target + extraGlasses ? () => onSet(glasses + 1) : null,
          semanticLabel: l10n.addWater,
          child: AnimatedContainer(
            duration: dur,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: reached ? t.water : t.water.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              reached ? l10n.waterGoalReached : l10n.addGlass,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: reached ? Colors.white : t.water,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
