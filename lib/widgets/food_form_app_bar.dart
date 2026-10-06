import 'package:flutter/material.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';

class FoodFormAppBar extends StatelessWidget {
  final bool isEditing;

  const FoodFormAppBar({
    super.key,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SliverAppBar(
      expandedHeight: 120.0,
      floating: true,
      pinned: true,
      backgroundColor: colorScheme.surface,
      iconTheme: IconThemeData(color: colorScheme.onSurface),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
        title: Text(
          isEditing ? l10n.editFoodTitle : l10n.addFoodTitle,
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
