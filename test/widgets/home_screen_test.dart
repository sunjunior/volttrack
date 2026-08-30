import 'package:drift/drift.dart' hide isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volttrack/core/models/battery.dart';
import 'package:volttrack/core/models/charge.dart';
import 'package:volttrack/data/tables.dart';
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

  testWidgets('只有无里程充电记录时显示概览而非空态', (tester) async {
    final db = openNullDatabase();
    await db.into(db.batteries).insert(BatteriesCompanion.insert(
          vehicleId: 1,
          name: '原装',
          type: BatteryType.ternaryLithium,
          voltageV: 48,
          capacityAh: 20,
          installedAt: DateTime(2026, 1, 1),
        ));
    await db.into(db.charges).insert(ChargesCompanion.insert(
          batteryId: 1,
          occurredAt: DateTime(2026, 2, 1, 8),
          mode: ChargeMode.byTime,
          energyKwh: 0.51,
          energySource: EnergySource.powerTimesHours,
          moneyYuan: const Value(2),
        ));
    await tester.pumpWidget(ProviderScope(
      overrides: [dbProvider.overrideWithValue(db)],
      child: const MaterialApp(home: HomeScreen()),
    ));
    await tester.pumpAndSettle();

    expect(find.text('还没有记账'), findsNothing);
    expect(find.text('累计花费'), findsOneWidget);
    expect(find.text('2.00'), findsOneWidget);
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
