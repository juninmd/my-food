import 'package:flutter/material.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/theme/app_motion.dart';
import 'package:webdiet/theme/app_tokens.dart';
import 'package:webdiet/theme/app_type.dart';
import 'package:webdiet/widgets/nav/nav_destinations.dart';

/// Desktop counterpart of the pill bar: a floating vertical rail with the
/// same sliding indicator.
class PillNavRail extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int marketBadge;

  static const _itemHeight = 72.0;

  const PillNavRail({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.marketBadge = 0,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final items = navDestinations(AppLocalizations.of(context)!);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: 96,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: t.card(radius: 28),
        child: Column(children: [
          Text('W', style: AppType.display(28, color: t.mint)),
          const SizedBox(height: 24),
          SizedBox(
            height: _itemHeight * items.length,
            child: Stack(children: [
              AnimatedPositioned(
                top: currentIndex * _itemHeight,
                left: 0,
                right: 0,
                height: _itemHeight,
                duration: AppMotion.of(context, AppMotion.spring),
                curve: AppMotion.springCurve,
                child: Container(
                  decoration: BoxDecoration(
                    color: t.ink,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              Column(children: [
                for (var i = 0; i < items.length; i++)
                  SizedBox(
                    height: _itemHeight,
                    child: _RailButton(
                      item: items[i],
                      selected: i == currentIndex,
                      badge: i == 1 ? marketBadge : 0,
                      onTap: () => onTap(i),
                    ),
                  ),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _RailButton extends StatelessWidget {
  final NavDestination item;
  final bool selected;
  final int badge;
  final VoidCallback onTap;

  const _RailButton({
    required this.item,
    required this.selected,
    required this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final color = selected ? t.paper : t.ink2;
    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Stack(alignment: Alignment.center, children: [
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(item.icon, color: color),
            const SizedBox(height: 4),
            Text(item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w700, color: color)),
          ]),
          if (badge > 0)
            Positioned(
                top: 10,
                right: 14,
                child: NavBadge(count: badge, color: t.protein)),
        ]),
      ),
    );
  }
}
