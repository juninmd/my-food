import 'package:flutter/material.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';
import 'package:my_food/data/meal_data.dart';
import 'package:my_food/widgets/modern_meal_card.dart';

class RecipesView extends StatelessWidget {
  const RecipesView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    final allRecipes = [
      ...MealData.getBreakfastOptions(l10n),
      ...MealData.getLunchOptions(l10n),
      ...MealData.getDinnerOptions(l10n),
    ];

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
              l10n.recipesTitle,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final recipe = allRecipes[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ModernMealCard(
                    meal: recipe,
                    title: l10n.recipesTitle,
                    onEdit: () {},
                  ),
                );
              },
              childCount: allRecipes.length,
            ),
          ),
        ),
      ],
    );
  }
}
