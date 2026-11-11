import 'package:flutter/material.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/pages/bmi_page.dart';
import 'package:webdiet/pages/random_recipe_page.dart';
import 'package:webdiet/theme/app_tokens.dart';
import 'package:webdiet/widgets/common/cascade_in.dart';
import 'package:webdiet/widgets/common/view_header.dart';
import 'package:webdiet/widgets/tool_card.dart';

/// The Tools tab: BMI, random recipe, Surprise Me and the catalog.
class ToolsView extends StatelessWidget {
  final VoidCallback onSurpriseMe;
  final VoidCallback? onOpenCatalog;

  const ToolsView({super.key, required this.onSurpriseMe, this.onOpenCatalog});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final t = AppTokens.of(context);
    void push(Widget page) =>
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));

    final tools = [
      ToolCard(
        icon: Icons.monitor_weight_outlined,
        title: l10n.bmiTitle,
        description: l10n.bmiCalculateTitle,
        color: t.water,
        onTap: () => push(const BMICalculatorPage()),
      ),
      ToolCard(
        icon: Icons.restaurant_menu_outlined,
        title: l10n.randomRecipeTitle,
        description: l10n.randomRecipeNew,
        color: t.protein,
        onTap: () => push(const RandomRecipePage()),
      ),
      ToolCard(
        icon: Icons.auto_fix_high,
        title: l10n.surpriseMeButton,
        description: l10n.surpriseMeSubtitle,
        color: t.mint,
        onTap: onSurpriseMe,
      ),
      if (onOpenCatalog != null)
        ToolCard(
          icon: Icons.grid_view_rounded,
          title: l10n.foodCatalogTitle,
          description: l10n.foodCatalogDesc,
          color: t.fat,
          onTap: onOpenCatalog!,
        ),
    ];

    return PageFrame(slivers: [
      SliverToBoxAdapter(
        child: ViewHeader(overline: l10n.toolsSubtitle, title: l10n.toolsTitle),
      ),
      SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 260,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          mainAxisExtent: 190,
        ),
        itemCount: tools.length,
        itemBuilder: (context, i) => CascadeIn(index: i, child: tools[i]),
      ),
    ]);
  }
}
