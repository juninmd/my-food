import 'package:flutter/material.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';
import 'package:my_food/pages/bmi_page.dart';
import 'package:my_food/pages/random_recipe_page.dart';

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
              _buildToolCard(
                context,
                icon: Icons.monitor_weight_outlined,
                title: l10n.bmiTitle,
                color: Colors.blue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BMICalculatorPage()),
                  );
                },
                description: l10n.bmiCalculateTitle, // Using existing string
              ),
              _buildToolCard(
                context,
                icon: Icons.auto_awesome_outlined,
                title: l10n.surpriseMeButton,
                color: Colors.purple,
                onTap: onSurpriseMe,
                description: l10n.surpriseMeFeedback, // Reuse localized string
              ),
              _buildToolCard(
                context,
                icon: Icons.restaurant_menu_outlined,
                title: l10n.randomRecipeTitle,
                color: Colors.orange,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RandomRecipePage()),
                  );
                },
                description: l10n.randomRecipeNew, // Reuse localized string
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToolCard(BuildContext context,
      {required IconData icon,
      required String title,
      required Color color,
      required VoidCallback onTap,
      required String description}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          splashColor: color.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 32),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
