import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volttrack/app.dart';
import 'package:volttrack/data/providers.dart';
import '../helpers/test_db.dart';

void main() {
  testWidgets('底部导航四个页签可切换', (tester) async {
    final db = openNullDatabase();
    await tester.pumpWidget(ProviderScope(
      overrides: [dbProvider.overrideWithValue(db)],
      child: const App(),
    ));
    expect(find.text('概览'), findsWidgets);
    await tester.tap(find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('统计'),
    ));
    await tester.pumpAndSettle();
    expect(find.byType(LineChart), findsOneWidget);
    await db.close();
  });
}
