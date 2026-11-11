import 'package:flutter/material.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/theme/app_motion.dart';
import 'package:webdiet/theme/app_tokens.dart';
import 'package:webdiet/theme/app_type.dart';

/// "3 of 14 in the cart" with a bar that springs forward on every check.
class ShoppingProgressCard extends StatelessWidget {
  final int done;
  final int total;

  const ShoppingProgressCard(
      {super.key, required this.done, required this.total});

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final l10n = AppLocalizations.of(context)!;
    final share = total == 0 ? 0.0 : done / total;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: t.card(),
      child: Column(children: [
        Row(children: [
          Expanded(
            child: Text(l10n.shoppingProgress(done, total),
                style: TextStyle(fontWeight: FontWeight.w700, color: t.ink)),
          ),
          Text('${(share * 100).round()}%',
              style: AppType.data(13, color: t.ink2)),
        ]),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Container(
            height: 10,
            color: t.sunk,
            alignment: Alignment.centerLeft,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: share),
              duration:
                  AppMotion.of(context, const Duration(milliseconds: 600)),
              curve: AppMotion.springCurve,
              builder: (context, v, _) => FractionallySizedBox(
                widthFactor: v.clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    gradient: LinearGradient(
                        colors: [t.mint, Color.lerp(t.mint, t.water, 0.4)!]),
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
