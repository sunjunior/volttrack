import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volttrack/core/models/battery.dart';
import 'package:volttrack/core/models/charge.dart';
import 'package:volttrack/data/providers.dart';
import 'package:volttrack/data/tables.dart';
import 'package:volttrack/features/charging/charging_screen.dart';
import '../helpers/test_db.dart';

void main() {
  Future<int> insertBattery(AppDatabase db) =>
      db.into(db.batteries).insert(BatteriesCompanion.insert(
            vehicleId: 1,
            name: '原装',
            type: BatteryType.ternaryLithium,
            voltageV: 48,
            capacityAh: 20,
            installedAt: DateTime(2026, 1, 1),
          ));

  testWidgets('有记录时列表渲染每行关键字段', (tester) async {
    final db = openNullDatabase();
    final batteryId = await insertBattery(db);
    await db.into(db.charges).insert(ChargesCompanion.insert(
          batteryId: batteryId,
          occurredAt: DateTime(2026, 2, 1, 8, 30),
          mode: ChargeMode.byTime,
          energyKwh: 0.51,
          energySource: EnergySource.powerTimesHours,
          moneyYuan: const Value(1.5),
          mileageKm: const Value(1000),
        ));
    await db.into(db.charges).insert(ChargesCompanion.insert(
          batteryId: batteryId,
          occurredAt: DateTime(2026, 1, 31, 20),
          mode: ChargeMode.byKwh,
          energyKwh: 1.2,
          energySource: EnergySource.manual,
        ));
    await tester.pumpWidget(ProviderScope(
      overrides: [dbProvider.overrideWithValue(db)],
      child: const MaterialApp(home: ChargingScreen()),
    ));
    await tester.pumpAndSettle();

    expect(find.text('2026-02-01 08:30'), findsOneWidget);
    expect(find.text('按时长'), findsOneWidget);
    expect(find.text('0.51 kWh'), findsOneWidget);
    expect(find.text('1.50 元'), findsOneWidget);
    expect(find.text('1000.0 km'), findsOneWidget);
    expect(find.text('按度数'), findsOneWidget);
    expect(find.text('1.20 kWh'), findsOneWidget);
    expect(find.text('还没有充电记录'), findsNothing);
    await db.close();
  });

  testWidgets('空列表显示引导空态并跳转记账表单', (tester) async {
    final db = openNullDatabase();
    await tester.pumpWidget(ProviderScope(
      overrides: [dbProvider.overrideWithValue(db)],
      child: const MaterialApp(home: ChargingScreen()),
    ));
    await tester.pumpAndSettle();

    expect(find.text('还没有充电记录'), findsOneWidget);
    await tester.tap(find.text('去记一笔'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('save')), findsOneWidget);
    await db.close();
  });

  testWidgets('删除单条记录需确认且库里只剩一行', (tester) async {
    final db = openNullDatabase();
    final batteryId = await insertBattery(db);
    await db.into(db.charges).insert(ChargesCompanion.insert(
          batteryId: batteryId,
          occurredAt: DateTime(2026, 2, 1, 8, 30),
          mode: ChargeMode.byTime,
          energyKwh: 0.51,
          energySource: EnergySource.powerTimesHours,
        ));
    final secondId = await db.into(db.charges).insert(ChargesCompanion.insert(
          batteryId: batteryId,
          occurredAt: DateTime(2026, 1, 31, 20),
          mode: ChargeMode.byKwh,
          energyKwh: 1.2,
          energySource: EnergySource.manual,
        ));
    await tester.pumpWidget(ProviderScope(
      overrides: [dbProvider.overrideWithValue(db)],
      child: const MaterialApp(home: ChargingScreen()),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key('delete_$secondId')));
    await tester.pumpAndSettle();
    expect(find.text('删除这条充电记录？'), findsOneWidget);

    await tester.tap(find.byKey(const Key('confirm_delete')));
    await tester.pumpAndSettle();

    final rows = await db.select(db.charges).get();
    expect(rows.length, 1);
    expect(find.text('1.20 kWh'), findsNothing);
    expect(find.text('0.51 kWh'), findsOneWidget);
    await db.close();
  });
}
