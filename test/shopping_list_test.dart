import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_food/widgets/shopping_list_view.dart';

void main() {
  group('ShoppingListView Widget Tests', () {
    final ingredients = [
      'Ovos',
      'Pão',
      'Ovos',
      'Leite'
    ]; // 2 Ovos, 1 Pão, 1 Leite

    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    Widget createLocalizedContext(Widget child) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: Scaffold(body: child),
      );
    }

    testWidgets('Displays aggregated ingredients correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(createLocalizedContext(
        ShoppingListView(ingredients: ingredients),
      ));

      // Verify title "Shopping List" (English)
      expect(find.text('Shopping List'), findsWidgets);

      // Verify ingredients
      expect(find.text('Ovos'), findsOneWidget);
      expect(find.text('Pão'), findsOneWidget);
      expect(find.text('Leite'), findsOneWidget);

      // Verify count for Ovos (x2)
      expect(find.text('x2'), findsOneWidget);
    });

    testWidgets('Toggles checkbox when item is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(createLocalizedContext(
        ShoppingListView(ingredients: ingredients),
      ));

      // Initially no check icons
      expect(find.byIcon(Icons.check), findsNothing);

      // Find the text 'Pão'
      final paoTextFinder = find.text('Pão');

      // Tap on 'Pão' text (which is inside the InkWell)
      await tester.tap(paoTextFinder);
      await tester.pumpAndSettle();

      // Now 'Pão' should have a check icon
      expect(find.byIcon(Icons.check), findsOneWidget);

      // Tap again to uncheck
      await tester.tap(paoTextFinder);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check), findsNothing);
    });

    testWidgets('Copy to clipboard triggers SnackBar',
        (WidgetTester tester) async {
      // Mock Clipboard
      final List<MethodCall> log = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform,
              (MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      });

      await tester.pumpWidget(createLocalizedContext(
        ShoppingListView(ingredients: ingredients),
      ));

      // Tap copy button
      await tester.tap(find.byIcon(Icons.copy));
      await tester.pump(); // Start animation
      await tester.pump(const Duration(seconds: 1)); // Wait for snackbar

      // Verify SnackBar "List copied to clipboard!"
      expect(find.text('List copied to clipboard!'), findsOneWidget);

      // Verify Clipboard was called
      expect(log, isNotEmpty);
      expect(log.last.method, 'Clipboard.setData');
      // The text is sent as a Map inside arguments
      final args = log.last.arguments as Map;
      final text = args['text'] as String;

      expect(text, contains('Shopping List:'));
      expect(text, contains('[ ] Leite'));
      expect(text, contains('[ ] Ovos (x2)'));
      expect(text, contains('[ ] Pão'));
    });
  });
}
