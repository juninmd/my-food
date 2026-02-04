import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_food/pages/shopping_list_page.dart';

void main() {
  group('ShoppingListPage Widget Tests', () {
    final ingredients = ['Ovos', 'Pão', 'Ovos', 'Leite']; // 2 Ovos, 1 Pão, 1 Leite

    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('Displays aggregated ingredients correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ShoppingListPage(ingredients: ingredients),
      ));

      // Verify title
      expect(find.text('Lista de Compras'), findsOneWidget);

      // Verify ingredients
      expect(find.text('Ovos'), findsOneWidget);
      expect(find.text('Pão'), findsOneWidget);
      expect(find.text('Leite'), findsOneWidget);

      // Verify count for Ovos (x2)
      // Note: The text might be "x2" in a trailing widget
      expect(find.text('x2'), findsOneWidget);
    });

    testWidgets('Toggles checkbox when item is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ShoppingListPage(ingredients: ingredients),
      ));

      // Initially unchecked
      expect(find.byIcon(Icons.check_box_outline_blank), findsNWidgets(3));
      expect(find.byIcon(Icons.check_box), findsNothing);

      // Tap on 'Pão'
      await tester.tap(find.text('Pão'));
      await tester.pump();

      // Now 'Pão' should be checked
      expect(find.byIcon(Icons.check_box), findsOneWidget);
      expect(find.byIcon(Icons.check_box_outline_blank), findsNWidgets(2));

      // Tap again to uncheck
      await tester.tap(find.text('Pão'));
      await tester.pump();

      expect(find.byIcon(Icons.check_box), findsNothing);
      expect(find.byIcon(Icons.check_box_outline_blank), findsNWidgets(3));
    });

    testWidgets('Copy to clipboard triggers SnackBar', (WidgetTester tester) async {
      // Mock Clipboard
      final List<MethodCall> log = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      });

      await tester.pumpWidget(MaterialApp(
        home: ShoppingListPage(ingredients: ingredients),
      ));

      // Tap copy button
      await tester.tap(find.byIcon(Icons.copy));
      await tester.pump(); // Start animation
      await tester.pump(const Duration(seconds: 1)); // Wait for snackbar

      // Verify SnackBar
      expect(find.text('Lista copiada para a área de transferência!'), findsOneWidget);

      // Verify Clipboard was called
      expect(log, isNotEmpty);
      expect(log.last.method, 'Clipboard.setData');
      // The text is sent as a Map inside arguments
      final args = log.last.arguments as Map;
      final text = args['text'] as String;

      expect(text, contains('Lista de Compras:'));
      expect(text, contains('[ ] Leite'));
      expect(text, contains('[ ] Ovos (x2)'));
      expect(text, contains('[ ] Pão'));
    });
  });
}
