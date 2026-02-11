import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';
import 'package:my_food/pages/random_recipe_page.dart';
import 'package:my_food/services/api_service.dart';

class SpyingApiService extends ApiService {
  bool disposeCalled = false;

  SpyingApiService({super.client});

  @override
  void dispose() {
    disposeCalled = true;
    super.dispose();
  }
}

void main() {
  Widget createLocalizedContext(Widget child) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: child,
    );
  }

  testWidgets('RandomRecipePage does NOT dispose injected ApiService',
      (WidgetTester tester) async {
    final client = MockClient((request) async {
      return http.Response('Error', 500);
    });

    final spyingApiService = SpyingApiService(client: client);

    await tester.pumpWidget(createLocalizedContext(
      RandomRecipePage(apiService: spyingApiService),
    ));

    // Wait for async operations
    await tester.pumpAndSettle();

    // Replace the widget to trigger dispose
    await tester.pumpWidget(Container());

    // Verify dispose was NOT called
    expect(spyingApiService.disposeCalled, isFalse);
  });
}
