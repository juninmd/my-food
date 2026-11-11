import 'package:flutter/material.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/theme/app_tokens.dart';
import 'package:webdiet/theme/app_type.dart';

/// Recipe card: photo with the name over it, category, instructions and
/// the button that deals another recipe.
class RandomRecipeContent extends StatelessWidget {
  final Map<String, dynamic> meal;
  final VoidCallback onRefresh;

  const RandomRecipeContent({
    super.key,
    required this.meal,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final t = AppTokens.of(context);
    final thumb = meal['strMealThumb'] as String?;

    final fallback = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [t.protein, t.carbs],
        ),
      ),
      child: const Center(
        child: Icon(Icons.restaurant_rounded, size: 56, color: Colors.white70),
      ),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Container(
              height: 280,
              clipBehavior: Clip.antiAlias,
              decoration: t.card(radius: 28),
              child: Stack(fit: StackFit.expand, children: [
                thumb == null
                    ? fallback
                    : Image.network(thumb,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => fallback),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black54],
                    ),
                  ),
                ),
                Positioned(
                  left: 18,
                  right: 18,
                  bottom: 18,
                  child: Text(
                    meal['strMeal'] ?? l10n.randomRecipeNoName,
                    style: AppType.display(28, color: Colors.white),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: t.mintSoft,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${l10n.randomRecipeCategoryPrefix}${meal['strCategory'] ?? l10n.randomRecipeNA}',
                  style: TextStyle(fontWeight: FontWeight.w700, color: t.mint),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(l10n.randomRecipeInstructions.toUpperCase(),
                style: AppType.label(t.ink2)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: t.card(),
              child: Text(
                meal['strInstructions'] ?? l10n.randomRecipeNoInstructions,
                style: TextStyle(color: t.ink, height: 1.6),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.style_rounded),
              label: Text(l10n.randomRecipeNew),
            ),
          ]),
        ),
      ),
    );
  }
}
