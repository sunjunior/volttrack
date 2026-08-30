import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volttrack/core/engine/charge_calculator.dart';
import 'package:volttrack/core/models/battery.dart';
import 'package:volttrack/data/providers.dart';
import 'package:volttrack/data/tables.dart';
import 'package:volttrack/features/calculator/calculator_screen.dart';
import '../helpers/test_db.dart';

void main() {
  testWidgets('输入度数后两方案对比并高亮更省方案', (tester) async {
    tester.view.physicalSize = const Size(600, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final db = openNullDatabase();
    await tester.pumpWidget(ProviderScope(
      overrides: [dbProvider.overrideWithValue(db)],
      child: const MaterialApp(home: CalculatorScreen()),
    ));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('energy')), '0.79');
    await tester.enterText(find.byKey(const Key('a_power')), '300');
    await tester.enterText(find.byKey(const Key('a_price')), '2');
    await tester.enterText(find.byKey(const Key('a_slice_hours')), '3');
    await tester.enterText(find.byKey(const Key('b_price')), '0.8');
    await tester.pumpAndSettle();

    // 方案 A 按时长档位：300W、2元/3小时 → 进一 2 档 → 4.00 元
    expect(find.text('4.00'), findsOneWidget);
    // 方案 B 按度：0.79 * 0.8 = 0.63 元
    expect(find.text('0.63'), findsOneWidget);

    // 更省方案：按度(B) 被高亮
    expect(find.byKey(const Key('cheap_b')), findsOneWidget);

    // 显示单次差额与月度差额
    final perDiff = (costByTimeSlices(
                energyKwh: 0.79,
                powerW: 300,
                yuanPerSlice: 2,
                sliceHours: 3) -
            costByKwh(energyKwh: 0.79, yuanPerKwh: 0.8))
        .toStringAsFixed(2);
    expect(find.textContaining('每次差额 $perDiff'), findsOneWidget);
    expect(find.textContaining('月度差额'), findsOneWidget);

    await db.close();
  });

  testWidgets('有当前电池时容量字段快捷填入', (tester) async {
    tester.view.physicalSize = const Size(600, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final db = openNullDatabase();
    await db.into(db.batteries).insert(BatteriesCompanion.insert(
          vehicleId: 1,
          name: '原装',
          type: BatteryType.ternaryLithium,
          voltageV: 48,
          capacityAh: 20,
          installedAt: DateTime(2026, 1, 1),
        ));
    await tester.pumpWidget(ProviderScope(
      overrides: [dbProvider.overrideWithValue(db)],
      child: const MaterialApp(home: CalculatorScreen()),
    ));
    await tester.pumpAndSettle();

    final field = tester.widget<TextField>(find.byKey(const Key('capacity')));
    expect(field.controller!.text, '0.96');
    await db.close();
  });
}
