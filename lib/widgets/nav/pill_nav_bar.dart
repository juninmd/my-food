import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/theme/app_motion.dart';
import 'package:webdiet/theme/app_tokens.dart';
import 'package:webdiet/widgets/nav/nav_destinations.dart';

/// Floating, frosted bottom navigation. A dark pill slides with a spring
/// to the selected tab; the Market tab carries a counter of items to buy.
class PillNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int marketBadge;

  const PillNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.marketBadge = 0,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final items = navDestinations(AppLocalizations.of(context)!);
    final x = -1 + 2 * currentIndex / (items.length - 1);

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            height: 68,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: t.surface.withValues(alpha: 0.86),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: t.line.withValues(alpha: 0.6)),
            ),
            child: Stack(children: [
              AnimatedAlign(
                alignment: Alignment(x, 0),
                duration: AppMotion.of(context, AppMotion.spring),
                curve: AppMotion.springCurve,
                child: FractionallySizedBox(
                  widthFactor: 1 / items.length,
                  heightFactor: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: t.ink,
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
              Row(children: [
                for (var i = 0; i < items.length; i++)
                  Expanded(
                    child: _NavButton(
                      item: items[i],
                      selected: i == currentIndex,
                      badge: i == 1 ? marketBadge : 0,
                      onTap: () => onTap(i),
                    ),
                  ),
              ]),
            ]),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final NavDestination item;
  final bool selected;
  final int badge;
  final VoidCallback onTap;

  const _NavButton({
    required this.item,
    required this.selected,
    required this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final color = selected ? t.paper : t.ink2;
    final d = AppMotion.of(context, const Duration(milliseconds: 300));
    return Semantics(
      selected: selected,
      button: true,
      child: InkResponse(
        onTap: onTap,
        radius: 36,
        child: Stack(alignment: Alignment.center, children: [
          Column(mainAxisSize: MainAxisSize.min, children: [
            AnimatedScale(
              scale: selected ? 1.1 : 1,
              duration: d,
              curve: AppMotion.springCurve,
              child: Icon(item.icon, size: 22, color: color),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: d,
              style: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w700, color: color),
              child: Text(item.label,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ]),
          if (badge > 0)
            Positioned(
              top: 2,
              right: 10,
              child: NavBadge(count: badge, color: t.protein),
            ),
        ]),
      ),
    );
  }
}
