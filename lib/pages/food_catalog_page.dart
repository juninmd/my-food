import 'package:flutter/material.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/models/food_item.dart';
import 'package:webdiet/pages/food_form_page.dart';
import 'package:webdiet/services/food_service.dart';
import 'package:webdiet/utils/food_filters.dart';
import 'package:webdiet/widgets/common/cascade_in.dart';
import 'package:webdiet/widgets/common/view_header.dart';
import 'package:webdiet/widgets/food_catalog/food_card.dart';
import 'package:webdiet/widgets/food_catalog/food_detail_sheet.dart';
import 'package:webdiet/widgets/food_catalog/food_search_bar.dart';
import 'package:webdiet/widgets/food_catalog_empty_state.dart';

/// The Catalog tab: the user's own foods, searchable and filterable,
/// with create, edit and delete (undoable).
class FoodCatalogPage extends StatefulWidget {
  /// Space kept under the add button for a floating bar drawn on top.
  final double bottomInset;

  const FoodCatalogPage({super.key, this.bottomInset = 0});

  @override
  State<FoodCatalogPage> createState() => _FoodCatalogPageState();
}

class _FoodCatalogPageState extends State<FoodCatalogPage> {
  final FoodService _foodService = FoodService();
  List<FoodItem> _foods = [];
  bool _isLoading = true;
  String _query = '';
  FoodFilter _filter = FoodFilter.all;

  @override
  void initState() {
    super.initState();
    _loadFoods();
  }

  Future<void> _loadFoods() async {
    final foods = await _foodService.getFoods();
    if (!mounted) return;
    setState(() {
      _foods = foods.reversed.toList();
      _isLoading = false;
    });
  }

  Future<void> _openForm([FoodItem? food]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FoodFormPage(foodToEdit: food)),
    );
    _loadFoods();
  }

  Future<void> _delete(FoodItem food) async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    await _foodService.deleteFood(food.id);
    await _loadFoods();
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(l10n.foodDeleted(food.name)),
        action: SnackBarAction(
          label: l10n.undo,
          onPressed: () async {
            await _foodService.saveFood(food);
            _loadFoods();
          },
        ),
      ));
  }

  void _openDetail(FoodItem food) {
    FoodDetailSheet.show(
      context,
      food: food,
      onEdit: () => _openForm(food),
      onDelete: () => _delete(food),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final visible = FoodFilters.apply(_foods, _filter, _query);

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: widget.bottomInset),
        child: FloatingActionButton(
          tooltip: l10n.addFoodTitle,
          onPressed: () => _openForm(),
          child: const Icon(Icons.add_rounded, size: 28),
        ),
      ),
      body: PageFrame(slivers: [
        SliverToBoxAdapter(
          child: ViewHeader(
              overline: l10n.catalogSubtitle, title: l10n.foodCatalogTitle),
        ),
        SliverToBoxAdapter(
          child: FoodSearchBar(
            filter: _filter,
            onQuery: (q) => setState(() => _query = q),
            onFilter: (f) => setState(() => _filter = f),
          ),
        ),
        if (_isLoading)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Center(child: CircularProgressIndicator()),
            ),
          )
        else if (_foods.isEmpty)
          SliverToBoxAdapter(
            child: FoodCatalogEmptyState(
                message: l10n.noFoodsYet, onAdd: () => _openForm()),
          )
        else if (visible.isEmpty)
          SliverToBoxAdapter(
            child: FoodCatalogEmptyState(
                message: l10n.noFoodsFound, onAdd: () => _openForm()),
          )
        else
          SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 240,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              mainAxisExtent: 196,
            ),
            itemCount: visible.length,
            itemBuilder: (context, i) => CascadeIn(
              key: ValueKey(visible[i].id),
              index: i,
              child: FoodCard(
                food: visible[i],
                onTap: () => _openDetail(visible[i]),
              ),
            ),
          ),
      ]),
    );
  }
}
