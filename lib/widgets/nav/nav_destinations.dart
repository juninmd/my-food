import 'package:flutter/material.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';

/// One tab of the home shell.
class NavDestination {
  final IconData icon;
  final String label;
  const NavDestination(this.icon, this.label);
}

/// Tabs in display order: Today, Market, Catalog, Tools.
List<NavDestination> navDestinations(AppLocalizations l10n) => [
      NavDestination(Icons.donut_large_rounded, l10n.todayTitle),
      NavDestination(Icons.shopping_bag_outlined, l10n.navMarket),
      NavDestination(Icons.grid_view_rounded, l10n.navCatalog),
      NavDestination(Icons.handyman_outlined, l10n.toolsTitle),
    ];

/// Small red counter on top of a navigation icon.
class NavBadge extends StatelessWidget {
  final int count;
  final Color color;
  const NavBadge({super.key, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: count > 0 ? 1 : 0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      child: Container(
        constraints: const BoxConstraints(minWidth: 16),
        height: 16,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          '$count',
          style: const TextStyle(
              color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
