import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/services/home_prefs.dart';
import 'package:webdiet/theme/app_tokens.dart';
import 'package:webdiet/utils/ingredient_categorizer.dart';
import 'package:webdiet/widgets/common/view_header.dart';
import 'package:webdiet/widgets/shopping_list/shopping_list_category.dart';
import 'package:webdiet/widgets/shopping_list/shopping_list_clipboard.dart';
import 'package:webdiet/widgets/shopping_list/shopping_progress_card.dart';

/// The Market tab: the day's ingredients grouped by aisle, with progress.
///
/// When [checked] and [onCheckedChanged] are given the parent owns the
/// checks (so the navigation badge stays in sync); otherwise the view
/// stores them on the device itself.
class ShoppingListView extends StatefulWidget {
  final List<String> ingredients;
  final Set<String>? checked;
  final ValueChanged<Set<String>>? onCheckedChanged;

  const ShoppingListView({
    super.key,
    required this.ingredients,
    this.checked,
    this.onCheckedChanged,
  });

  @override
  State<ShoppingListView> createState() => _ShoppingListViewState();
}

class _ShoppingListViewState extends State<ShoppingListView> {
  late Set<String> _checked = {...?widget.checked};

  @override
  void initState() {
    super.initState();
    if (widget.checked == null) _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(HomePrefs.checkedKey);
    if (!mounted || saved == null) return;
    setState(() => _checked = saved.toSet());
  }

  void _update(Set<String> next) {
    setState(() => _checked = next);
    if (widget.onCheckedChanged != null) {
      widget.onCheckedChanged!(next);
    } else {
      HomePrefs().saveChecked(next);
    }
  }

  void _toggle(String ingredient, bool value) {
    final next = {..._checked};
    value ? next.add(ingredient) : next.remove(ingredient);
    _update(next);
    final all = widget.ingredients.toSet();
    if (value && all.every(next.contains)) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.listComplete)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final t = AppTokens.of(context);

    final counts = <String, int>{};
    for (final i in widget.ingredients) {
      counts[i] = (counts[i] ?? 0) + 1;
    }
    final byCategory = <String, List<String>>{};
    for (final i in counts.keys) {
      byCategory
          .putIfAbsent(IngredientCategorizer.getCategory(i, l10n), () => [])
          .add(i);
    }
    final categories = byCategory.keys.toList()..sort();
    if (categories.remove(l10n.catOther)) categories.add(l10n.catOther);
    final done = counts.keys.where(_checked.contains).length;

    return PageFrame(maxWidth: 720, slivers: [
      SliverToBoxAdapter(
        child: ViewHeader(
          overline: l10n.shoppingFromPlan,
          title: l10n.shoppingListTitle,
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            if (_checked.isNotEmpty)
              IconButton(
                tooltip: l10n.clearChecked,
                onPressed: () => _update({}),
                icon: Icon(Icons.restart_alt_rounded, color: t.ink2),
              ),
            FilledButton.icon(
              onPressed: () =>
                  copyShoppingListToClipboard(context, l10n, counts, _checked),
              icon: const Icon(Icons.copy_rounded, size: 18),
              label: Text(l10n.shoppingListCopyTooltip),
            ),
          ]),
        ),
      ),
      SliverToBoxAdapter(
        child: ShoppingProgressCard(done: done, total: counts.length),
      ),
      SliverList.separated(
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, i) => ShoppingListCategory(
          index: i,
          category: categories[i],
          ingredients: byCategory[categories[i]]!..sort(),
          ingredientCounts: counts,
          checkedIngredients: _checked,
          onIngredientChecked: _toggle,
        ),
      ),
    ]);
  }
}
