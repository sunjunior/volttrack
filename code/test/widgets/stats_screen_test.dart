import 'package:drift/drift.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volttrack/core/models/battery.dart';
import 'package:volttrack/core/models/charge.dart';
import 'package:volttrack/data/providers.dart';
import 'package:volttrack/data/tables.dart';
import 'package:volttrack/features/stats/stats_screen.dart';
import '../helpers/test_db.dart';

void main() {
  testWidgets('有窗口数据时渲染折线图', (tester) async {
    final db = openNullDatabase();
    final batteryId = await db.into(db.batteries).insert(BatteriesCompanion.insert(
      vehicleId: 1, name: '原装', type: BatteryType.ternaryLithium,
      voltageV: 48, capacityAh: 20, installedAt: DateTime(2026, 1, 1),
    ));
    await db.into(db.charges).insert(ChargesCompanion.insert(
      batteryId: batteryId, occurredAt: DateTime(2026, 1, 1, 8),
      mode: ChargeMode.byTime, energyKwh: 0.72, energySource: EnergySource.manual,
      socBeforePct: const Value(30), socAfterPct: const Value(100),
      mileageKm: const Value(1000),
    ));
    await db.into(db.charges).insert(ChargesCompanion.insert(
      batteryId: batteryId, occurredAt: DateTime(2026, 1, 2, 8),
      mode: ChargeMode.byTime, energyKwh: 0, energySource: EnergySource.manual,
      socBeforePct: const Value(45), mileageKm: const Value(1060),
    ));
    await tester.pumpWidget(ProviderScope(
      overrides: [dbProvider.overrideWithValue(db)],
      child: const MaterialApp(home: StatsScreen()),
    ));
    await tester.pumpAndSettle();
    expect(find.byType(LineChart), findsOneWidget);
    await db.close();
  });

  testWidgets('SOH 只取低电量起点充至满电的窗口', (tester) async {
    final db = openNullDatabase();
    final batteryId = await db.into(db.batteries).insert(BatteriesCompanion.insert(
      vehicleId: 1, name: '原装', type: BatteryType.ternaryLithium,
      voltageV: 48, capacityAh: 20, installedAt: DateTime(2026, 1, 1),
    ));
    // 补电窗口：80→100，不满足满充门槛，不参与 SOH
    await db.into(db.charges).insert(ChargesCompanion.insert(
      batteryId: batteryId, occurredAt: DateTime(2026, 1, 1, 8),
      mode: ChargeMode.byTime, energyKwh: 0.5, energySource: EnergySource.manual,
      socBeforePct: const Value(80), socAfterPct: const Value(100),
      mileageKm: const Value(1000),
    ));
    await db.into(db.charges).insert(ChargesCompanion.insert(
      batteryId: batteryId, occurredAt: DateTime(2026, 1, 2, 8),
      mode: ChargeMode.byTime, energyKwh: 0.1, energySource: EnergySource.manual,
      socBeforePct: const Value(45), mileageKm: const Value(1060),
    ));
    // 满充窗口：5→100，参与 SOH：0.9/(0.96×0.95)=98.7%
    await db.into(db.charges).insert(ChargesCompanion.insert(
      batteryId: batteryId, occurredAt: DateTime(2026, 1, 3, 8),
      mode: ChargeMode.byTime, energyKwh: 0.9, energySource: EnergySource.manual,
      socBeforePct: const Value(5), socAfterPct: const Value(100),
      mileageKm: const Value(1120),
    ));
    await db.into(db.charges).insert(ChargesCompanion.insert(
      batteryId: batteryId, occurredAt: DateTime(2026, 1, 4, 8),
      mode: ChargeMode.byTime, energyKwh: 0, energySource: EnergySource.manual,
      socBeforePct: const Value(20), mileageKm: const Value(1180),
    ));
    await tester.pumpWidget(ProviderScope(
      overrides: [dbProvider.overrideWithValue(db)],
      child: const MaterialApp(home: StatsScreen()),
    ));
    await tester.pumpAndSettle();

    expect(find.text('98.7%'), findsOneWidget);
    expect(find.text('120.0%'), findsNothing);
    await db.close();
  });

  testWidgets('SOH 多个满电窗口时取最近的窗口估算', (tester) async {
    final db = openNullDatabase();
    final batteryId = await db.into(db.batteries).insert(BatteriesCompanion.insert(
      vehicleId: 1, name: '原装', type: BatteryType.ternaryLithium,
      voltageV: 48, capacityAh: 20, installedAt: DateTime(2026, 1, 1),
    ));
    // 普通锚点：50→100，不满足满充门槛
    await db.into(db.charges).insert(ChargesCompanion.insert(
      batteryId: batteryId, occurredAt: DateTime(2026, 1, 1, 8),
      mode: ChargeMode.byTime, energyKwh: 0.5, energySource: EnergySource.manual,
      socBeforePct: const Value(50), socAfterPct: const Value(100),
      mileageKm: const Value(1000),
    ));
    // 较早满充窗口起点：5→100，SOH=0.72/(0.96×0.95)=78.9%
    await db.into(db.charges).insert(ChargesCompanion.insert(
      batteryId: batteryId, occurredAt: DateTime(2026, 1, 2, 8),
      mode: ChargeMode.byTime, energyKwh: 0.72, energySource: EnergySource.manual,
      socBeforePct: const Value(5), socAfterPct: const Value(100),
      mileageKm: const Value(1060),
    ));
    // 最近满充窗口起点：10→100，SOH=0.864/(0.96×0.90)=100.0%
    await db.into(db.charges).insert(ChargesCompanion.insert(
      batteryId: batteryId, occurredAt: DateTime(2026, 1, 3, 8),
      mode: ChargeMode.byTime, energyKwh: 0.864, energySource: EnergySource.manual,
      socBeforePct: const Value(10), socAfterPct: const Value(100),
      mileageKm: const Value(1120),
    ));
    await db.into(db.charges).insert(ChargesCompanion.insert(
      batteryId: batteryId, occurredAt: DateTime(2026, 1, 4, 8),
      mode: ChargeMode.byTime, energyKwh: 0.1, energySource: EnergySource.manual,
      socBeforePct: const Value(20), mileageKm: const Value(1180),
    ));
    await tester.pumpWidget(ProviderScope(
      overrides: [dbProvider.overrideWithValue(db)],
      child: const MaterialApp(home: StatsScreen()),
    ));
    await tester.pumpAndSettle();

    expect(find.text('100.0%'), findsOneWidget);
    expect(find.text('78.9%'), findsNothing);
    await db.close();
  });

  testWidgets('空数据时折线图与空态文案正常', (tester) async {
    final db = openNullDatabase();
    await tester.pumpWidget(ProviderScope(
      overrides: [dbProvider.overrideWithValue(db)],
      child: const MaterialApp(home: StatsScreen()),
    ));
    await tester.pumpAndSettle();
    expect(find.byType(LineChart), findsOneWidget);
    expect(find.text('当前生效电池'), findsOneWidget);
    expect(find.text('未添加'), findsOneWidget);
    expect(find.text('数据积累中'), findsOneWidget);
    expect(find.text('档案中填写官方续航后可计算达成率'), findsOneWidget);
    await db.close();
  });
}
