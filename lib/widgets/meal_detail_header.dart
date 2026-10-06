import 'package:flutter/material.dart';
import 'package:webdiet/models/meal.dart';

class MealDetailHeader extends StatelessWidget {
  final Meal meal;
  final String heroTag;

  const MealDetailHeader({
    super.key,
    required this.meal,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withValues(alpha: 0.9),
            foregroundColor: Colors.black,
            elevation: 0,
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: heroTag,
          child: Image.asset(
            meal.imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey.shade200,
                child: Center(
                  child: Icon(
                    Icons.restaurant_menu_rounded,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
