import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webdiet/widgets/shopping_list/shopping_list_item_tile.dart';
import 'package:webdiet/widgets/shopping_list_view.dart';

import 'helpers/localized_app.dart';

void main() {
  group('ShoppingListView Widget Tests', () {
    final ingredients = ['Ovos', 'Pão', 'Ovos', 'Leite'];

    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    Widget app(Widget child) => localizedApp(Scaffold(body: child));

    ShoppingListItemTile tile(WidgetTester tester, String name) =>
        tester.widget<ShoppingListItemTile>(
            find.widgetWithText(ShoppingListItemTile, name));

    testWidgets('Displays aggregated ingredients and progress',
        (WidgetTester tester) async {
      await tester.pumpWidget(app(ShoppingListView(ingredients: ingredients)));
      await tester.pumpAndSettle();

      expect(find.text('Shopping List'), findsWidgets);
      expect(find.text('Ovos'), findsOneWidget);
      expect(find.text('Pão'), findsOneWidget);
      expect(find.text('Leite'), findsOneWidget);
      expect(find.text('x2'), findsOneWidget);
      expect(find.text('0 of 3 in the cart'), findsOneWidget);
    });

    testWidgets('Toggles an item and saves the check',
        (WidgetTester tester) async {
      await tester.pumpWidget(app(ShoppingListView(ingredients: ingredients)));
      await tester.pumpAndSettle();

      expect(tile(tester, 'Pão').isChecked, isFalse);
      await tester.tap(find.text('Pão'));
      await tester.pumpAndSettle();
      expect(tile(tester, 'Pão').isChecked, isTrue);
      expect(find.text('1 of 3 in the cart'), findsOneWidget);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getStringList('checked_ingredients'), ['Pão']);

      await tester.tap(find.text('Pão'));
      await tester.pumpAndSettle();
      expect(tile(tester, 'Pão').isChecked, isFalse);
    });

    testWidgets('Reports checks to the parent when it owns them',
        (WidgetTester tester) async {
      Set<String>? reported;
      await tester.pumpWidget(app(ShoppingListView(
        ingredients: ingredients,
        checked: const {'Leite'},
        onCheckedChanged: (s) => reported = s,
      )));
      await tester.pumpAndSettle();

      expect(tile(tester, 'Leite').isChecked, isTrue);
      await tester.tap(find.text('Ovos'));
      await tester.pumpAndSettle();
      expect(reported, {'Leite', 'Ovos'});
    });

    testWidgets('Checking every item shows "List complete"',
        (WidgetTester tester) async {
      await tester.pumpWidget(app(ShoppingListView(ingredients: ingredients)));
      await tester.pumpAndSettle();
      for (final name in ['Ovos', 'Pão', 'Leite']) {
        await tester.tap(find.text(name));
        await tester.pumpAndSettle();
      }
      expect(find.text('List complete'), findsOneWidget);
    });

    testWidgets('Copy to clipboard triggers SnackBar',
        (WidgetTester tester) async {
      final List<MethodCall> log = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform,
              (MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      });

      await tester.pumpWidget(app(ShoppingListView(ingredients: ingredients)));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.copy_rounded));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('List copied to clipboard!'), findsOneWidget);
      final setData = log
          .lastWhere((c) => c.method == 'Clipboard.setData')
          .arguments as Map;
      final text = setData['text'] as String;
      expect(text, contains('Shopping List:'));
      expect(text, contains('[ ] Leite'));
      expect(text, contains('[ ] Ovos (x2)'));
      expect(text, contains('[ ] Pão'));
    });
  });
}
