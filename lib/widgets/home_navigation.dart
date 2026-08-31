import 'package:flutter/material.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';

class HomeNavigation {
  static Widget buildDesktopRail(
    BuildContext context,
    int currentIndex,
    ValueChanged<int> onDestinationSelected,
    AppLocalizations l10n,
  ) {
    return NavigationRail(
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      labelType: NavigationRailLabelType.all,
      destinations: [
        NavigationRailDestination(
          icon: const Icon(Icons.dashboard_outlined),
          selectedIcon: const Icon(Icons.dashboard_rounded),
          label: Text(l10n.mealPageTitle),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.shopping_bag_outlined),
          selectedIcon: const Icon(Icons.shopping_bag_rounded),
          label: Text(l10n.shoppingListTitle),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.fastfood_outlined),
          selectedIcon: const Icon(Icons.fastfood_rounded),
          label: Text(l10n.foodCatalogTitle),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.grid_view),
          selectedIcon: const Icon(Icons.grid_view_rounded),
          label: Text(l10n.toolsTitle),
        ),
      ],
    );
  }

  static Widget buildBottomBar(
    BuildContext context,
    int currentIndex,
    ValueChanged<int> onTap,
    AppLocalizations l10n,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          items: [
            BottomNavigationBarItem(
                icon: const Icon(Icons.dashboard_outlined),
                activeIcon: const Icon(Icons.dashboard_rounded),
                label: l10n.mealPageTitle),
            BottomNavigationBarItem(
                icon: const Icon(Icons.shopping_bag_outlined),
                activeIcon: const Icon(Icons.shopping_bag_rounded),
                label: l10n.shoppingListTitle),
            BottomNavigationBarItem(
                icon: const Icon(Icons.fastfood_outlined),
                activeIcon: const Icon(Icons.fastfood_rounded),
                label: l10n.foodCatalogTitle),
            BottomNavigationBarItem(
                icon: const Icon(Icons.grid_view),
                activeIcon: const Icon(Icons.grid_view_rounded),
                label: l10n.toolsTitle),
          ],
        ),
      ),
    );
  }
}
