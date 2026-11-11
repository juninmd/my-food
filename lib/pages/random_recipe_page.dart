import 'package:flutter/material.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/services/api_service.dart';
import 'package:webdiet/theme/app_motion.dart';
import 'package:webdiet/theme/app_tokens.dart';
import 'package:webdiet/widgets/random_recipe_content.dart';

/// A random recipe from TheMealDB. Asking for another one throws the
/// current card off to the side and deals the next.
class RandomRecipePage extends StatefulWidget {
  final ApiService? apiService;

  const RandomRecipePage({super.key, this.apiService});

  @override
  State<RandomRecipePage> createState() => _RandomRecipePageState();
}

class _RandomRecipePageState extends State<RandomRecipePage> {
  late ApiService _apiService;
  late Future<Map<String, dynamic>> _recipeFuture;
  int _deal = 0;

  @override
  void initState() {
    super.initState();
    _apiService = widget.apiService ?? ApiService();
    _recipeFuture = _apiService.fetchRandomRecipe();
  }

  void _refreshRecipe() {
    setState(() {
      _deal++;
      _recipeFuture = _apiService.fetchRandomRecipe();
    });
  }

  @override
  void dispose() {
    if (widget.apiService == null) _apiService.dispose();
    super.dispose();
  }

  Widget _transition(Widget child, Animation<double> a, Key current) {
    if (child.key == current) {
      return FadeTransition(
        opacity: a,
        child: SlideTransition(
          position:
              Tween(begin: const Offset(0, 0.06), end: Offset.zero).animate(a),
          child: child,
        ),
      );
    }
    return SlideTransition(
      position: Tween(begin: const Offset(1.3, 0), end: Offset.zero).animate(a),
      child: RotationTransition(
        turns: Tween(begin: 0.05, end: 0.0).animate(a),
        child: child,
      ),
    );
  }

  Widget _body(BuildContext context, AsyncSnapshot<Map<String, dynamic>> snap) {
    final l10n = AppLocalizations.of(context)!;
    final t = AppTokens.of(context);
    if (snap.connectionState == ConnectionState.waiting) {
      return const Center(
          key: ValueKey('loading'), child: CircularProgressIndicator());
    }
    if (snap.hasError) {
      return Center(
        key: const ValueKey('error'),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.cloud_off_rounded, size: 48, color: t.protein),
            const SizedBox(height: 16),
            Text('${l10n.randomRecipeErrorPrefix}${l10n.recipeLoadError}',
                textAlign: TextAlign.center, style: TextStyle(color: t.ink2)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _refreshRecipe,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l10n.randomRecipeRetry),
            ),
          ]),
        ),
      );
    }
    if (snap.hasData) {
      return RandomRecipeContent(
        key: ValueKey('recipe$_deal'),
        meal: snap.data!,
        onRefresh: _refreshRecipe,
      );
    }
    return Center(
        key: const ValueKey('empty'), child: Text(l10n.randomRecipeNoData));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.randomRecipeTitle)),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _recipeFuture,
        builder: (context, snap) {
          final child = _body(context, snap);
          return AnimatedSwitcher(
            duration: AppMotion.of(context, AppMotion.spring),
            switchInCurve: AppMotion.decel,
            transitionBuilder: (c, a) => _transition(c, a, child.key!),
            child: child,
          );
        },
      ),
    );
  }
}
