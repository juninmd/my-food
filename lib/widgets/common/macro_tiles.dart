import 'package:flutter/material.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/theme/app_tokens.dart';
import 'package:webdiet/theme/app_type.dart';
import 'package:webdiet/utils/nutrition_math.dart';

/// "300 kcal · P15 C30 F12" with the macro initials of the current language.
String macroLine(AppLocalizations l10n, int kcal, int p, int c, int f) =>
    '$kcal kcal · ${l10n.macroProtein[0]}$p ${l10n.macroCarbs[0]}$c '
    '${l10n.macroFat[0]}$f';

/// Four equal tiles: kcal, protein, carbs, fat, each in its data color.
class MacroTiles extends StatelessWidget {
  final int calories;
  final int protein;
  final int carbs;
  final int fat;

  const MacroTiles({
    super.key,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final l10n = AppLocalizations.of(context)!;
    Widget tile(String value, String label, Color color) => Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            decoration: BoxDecoration(
              color: t.sunk,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(children: [
              FittedBox(
                  child: Text(value, style: AppType.data(18, color: color))),
              const SizedBox(height: 2),
              Text(label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: t.ink2)),
            ]),
          ),
        );
    return Row(children: [
      tile('$calories', 'kcal', t.mint),
      const SizedBox(width: 8),
      tile('${protein}g', l10n.macroProtein, t.protein),
      const SizedBox(width: 8),
      tile('${carbs}g', l10n.macroCarbs, t.carbs),
      const SizedBox(width: 8),
      tile('${fat}g', l10n.macroFat, t.fat),
    ]);
  }
}

/// Thin bar split by calorie share: the "DNA" of a food.
class MacroDnaBar extends StatelessWidget {
  final int protein;
  final int carbs;
  final int fat;

  const MacroDnaBar(
      {super.key,
      required this.protein,
      required this.carbs,
      required this.fat});

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final s = NutritionMath.calorieShares(protein, carbs, fat);
    final colors = [t.protein, t.carbs, t.fat];
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: SizedBox(
        height: 6,
        child: Row(children: [
          for (var i = 0; i < 3; i++)
            if (s[i] > 0)
              Expanded(
                flex: (s[i] * 1000).round().clamp(1, 1000),
                child: Container(
                  margin: EdgeInsets.only(right: i < 2 ? 2 : 0),
                  color: colors[i],
                ),
              ),
        ]),
      ),
    );
  }
}
