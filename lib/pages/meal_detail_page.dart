import 'package:flutter/material.dart';
import 'package:webdiet/models/meal.dart';
import 'package:webdiet/widgets/meal_detail_header.dart';
import 'package:webdiet/widgets/meal_detail_body.dart';

class MealDetailPage extends StatelessWidget {
  final Meal meal;
  final VoidCallback? onSwap;
  final String heroTag;

  const MealDetailPage({
    super.key,
    required this.meal,
    this.onSwap,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          MealDetailHeader(
            meal: meal,
            heroTag: heroTag,
          ),
          MealDetailBody(
            meal: meal,
            onSwap: onSwap,
          ),
        ],
      ),
    );
  }
}
