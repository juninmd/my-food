import 'package:flutter/material.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/theme/app_motion.dart';
import 'package:webdiet/theme/app_tokens.dart';
import 'package:webdiet/utils/food_filters.dart';

/// Search field plus a row of quick filter chips.
class FoodSearchBar extends StatelessWidget {
  final FoodFilter filter;
  final ValueChanged<String> onQuery;
  final ValueChanged<FoodFilter> onFilter;

  const FoodSearchBar({
    super.key,
    required this.filter,
    required this.onQuery,
    required this.onFilter,
  });

  String _label(AppLocalizations l10n, FoodFilter f) => switch (f) {
        FoodFilter.all => l10n.filterAll,
        FoodFilter.highProtein => l10n.filterHighProtein,
        FoodFilter.lowCarb => l10n.filterLowCarb,
        FoodFilter.light => l10n.filterLight,
      };

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Container(
        decoration: t.card(radius: 18),
        child: TextField(
          onChanged: onQuery,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: l10n.searchFoodHint,
            prefixIcon: Icon(Icons.search_rounded, color: t.ink2),
            filled: true,
            fillColor: t.surface,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
          ),
        ),
      ),
      const SizedBox(height: 12),
      SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: FoodFilter.values.length,
          separatorBuilder: (_, __) => const SizedBox(width: 6),
          itemBuilder: (context, i) {
            final f = FoodFilter.values[i];
            final on = f == filter;
            return Semantics(
              selected: on,
              button: true,
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: () => onFilter(f),
                child: AnimatedContainer(
                  duration:
                      AppMotion.of(context, const Duration(milliseconds: 250)),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: on ? t.ink : t.surface,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: on ? t.ink : t.line),
                  ),
                  child: Text(
                    _label(l10n, f),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: on ? t.paper : t.ink,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 16),
    ]);
  }
}
