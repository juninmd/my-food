import 'package:flutter/material.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';

class FoodCatalogAppBar extends StatelessWidget {
  final ValueChanged<String> onFilterFoods;

  const FoodCatalogAppBar({
    super.key,
    required this.onFilterFoods,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SliverAppBar(
      expandedHeight: 180.0,
      floating: true,
      pinned: true,
      backgroundColor: colorScheme.surface,
      iconTheme: IconThemeData(color: colorScheme.onSurface),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 24, bottom: 80),
        title: Text(
          l10n.foodCatalogTitle,
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: TextField(
            onChanged: onFilterFoods,
            decoration: InputDecoration(
              hintText: l10n.searchFoodHint,
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: theme.scaffoldBackgroundColor,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
