import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volttrack/features/home/home_screen.dart';
import 'package:volttrack/data/providers.dart';
import '../helpers/test_db.dart';

void main() {
  testWidgets('空数据时显示引导空态', (tester) async {
    final db = openNullDatabase(); // 内存库提供者
    await tester.pumpWidget(ProviderScope(
      overrides: [dbProvider.overrideWithValue(db)],
      child: const MaterialApp(home: HomeScreen()),
    ));
    await tester.pumpAndSettle();
    expect(find.text('还没有记账'), findsOneWidget);
    expect(find.text('去记账'), findsOneWidget);
    await db.close();
  });

  testWidgets('点击引导按钮触发 onGoToCharging', (tester) async {
    final db = openNullDatabase();
    var tapped = false;
    await tester.pumpWidget(ProviderScope(
      overrides: [dbProvider.overrideWithValue(db)],
      child: MaterialApp(home: HomeScreen(onGoToCharging: () => tapped = true)),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('去记账'));
    expect(tapped, isTrue);
    await db.close();
  });
}
