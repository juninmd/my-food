import 'package:flutter/material.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/pages/bmi_page.dart';
import 'package:webdiet/pages/random_recipe_page.dart';
import 'package:webdiet/pages/food_catalog_page.dart';
import 'package:webdiet/widgets/tool_card.dart';

class ToolsView extends StatelessWidget {
  final VoidCallback onSurpriseMe;

  const ToolsView({super.key, required this.onSurpriseMe});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 120.0,
          floating: true,
          pinned: true,
          backgroundColor: colorScheme.surface,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: false,
            titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
            title: Text(
              l10n.toolsTitle,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(24),
          sliver: SliverGrid.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8,
            children: [
              ToolCard(
                icon: Icons.monitor_weight_outlined,
                title: l10n.bmiTitle,
                color: colorScheme.primary,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BMICalculatorPage()),
                  );
                },
                description: l10n.bmiCalculateTitle, // Using existing string
              ),
              ToolCard(
                icon: Icons.auto_fix_high_outlined,
                title: l10n.surpriseMeButton,
                color: colorScheme.primary,
                onTap: onSurpriseMe,
                description: l10n.surpriseMeFeedback, // Reuse localized string
              ),
              ToolCard(
                icon: Icons.restaurant_menu_outlined,
                title: l10n.randomRecipeTitle,
                color: colorScheme.primary,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RandomRecipePage()),
                  );
                },
                description: l10n.randomRecipeNew, // Reuse localized string
              ),
              ToolCard(
                icon: Icons.fastfood_outlined,
                title: l10n.foodCatalogTitle,
                color: colorScheme.primary,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FoodCatalogPage()),
                  );
                },
                description: l10n.foodCatalogDesc,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
