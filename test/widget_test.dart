import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webdiet/main.dart';
import 'package:webdiet/widgets/today/day_line_tile.dart';
import 'package:webdiet/widgets/today/orbit_card.dart';
import 'package:webdiet/widgets/today/water_card.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App smoke test shows the Today tab', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(OrbitCard), findsOneWidget);
    expect(find.byType(WaterCard), findsOneWidget);
    expect(find.text('Calories'), findsOneWidget);

    await tester.drag(
        find.byType(CustomScrollView).first, const Offset(0, -500));
    await tester.pumpAndSettle();

    expect(find.text('AI Recommendation'), findsOneWidget);
    expect(find.byType(DayLineTile), findsNWidgets(3));
  });

  testWidgets('Adding water updates the counter', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('0 / 8 glasses (250ml)'), findsOneWidget);
    await tester.tap(find.text('+ 1 glass'));
    await tester.pumpAndSettle();
    expect(find.text('1 / 8 glasses (250ml)'), findsOneWidget);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getInt('water_glasses'), 1);
  });
}
