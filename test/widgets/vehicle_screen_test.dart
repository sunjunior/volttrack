import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volttrack/core/models/battery.dart';
import 'package:volttrack/core/models/charge.dart';
import 'package:volttrack/data/providers.dart';
import 'package:volttrack/data/tables.dart';
import 'package:volttrack/features/vehicle/vehicle_form.dart';
import 'package:volttrack/features/vehicle/vehicle_screen.dart';
import '../helpers/test_db.dart';

void main() {
  testWidgets('无车辆时电池表单保存被拒且不写库', (tester) async {
    final db = openNullDatabase();
    await tester.pumpWidget(ProviderScope(
      overrides: [dbProvider.overrideWithValue(db)],
      child: const MaterialApp(home: VehicleForm()),
    ));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('name')), '原装');
    await tester.enterText(find.byKey(const Key('voltage')), '48');
    await tester.enterText(find.byKey(const Key('capacity')), '20');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save')));
    await tester.pumpAndSettle();

    final rows = await db.select(db.batteries).get();
    expect(rows.length, 0);
    expect(find.text('请先添加车辆'), findsOneWidget);
    await db.close();
  });

  testWidgets('建档车辆后保存电池使用该车辆 id', (tester) async {
    final db = openNullDatabase();
    await tester.pumpWidget(ProviderScope(
      overrides: [dbProvider.overrideWithValue(db)],
      child: const MaterialApp(home: VehicleScreen()),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('add_vehicle')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('brand')), '雅迪');
    await tester.enterText(find.byKey(const Key('model')), 'DE3');
    await tester.tap(find.byKey(const Key('save')));
    await tester.pumpAndSettle();
    expect(find.text('雅迪 DE3'), findsOneWidget);

    await tester.tap(find.text('更换电池'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('name')), '原装');
    await tester.enterText(find.byKey(const Key('voltage')), '48');
    await tester.enterText(find.byKey(const Key('capacity')), '20');
    await tester.tap(find.byKey(const Key('save')));
    await tester.pumpAndSettle();

    final vehicles = await db.select(db.vehicles).get();
    final batteries = await db.select(db.batteries).get();
    expect(vehicles, hasLength(1));
    expect(batteries, hasLength(1));
    expect(batteries.single.vehicleId, vehicles.single.id);
    await db.close();
  });

  testWidgets('预置生效电池时渲染名称与规格', (tester) async {
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
      child: const MaterialApp(home: VehicleScreen()),
    ));
    await tester.pumpAndSettle();
    expect(find.text('原装'), findsOneWidget);
    expect(find.text('48V20Ah'), findsOneWidget);
    expect(find.text('当前生效'), findsOneWidget);
    await db.close();
  });

  testWidgets('更换电池后旧电池停用且新电池生效', (tester) async {
    final db = openNullDatabase();
    await db.into(db.vehicles).insert(VehiclesCompanion.insert(
          brand: '雅迪',
          model: 'DE3',
        ));
    final oldId = await db.into(db.batteries).insert(BatteriesCompanion.insert(
          vehicleId: 1,
          name: '旧电池',
          type: BatteryType.leadAcid,
          voltageV: 48,
          capacityAh: 20,
          installedAt: DateTime(2025, 1, 1),
        ));
    await tester.pumpWidget(ProviderScope(
      overrides: [dbProvider.overrideWithValue(db)],
      child: const MaterialApp(home: VehicleScreen()),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('更换电池'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('name')), '新电池');
    await tester.tap(find.byKey(const Key('type')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('三元锂').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('voltage')), '48');
    await tester.enterText(find.byKey(const Key('capacity')), '20');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save')));
    await tester.pumpAndSettle();

    final rows = await db.select(db.batteries).get();
    expect(rows.length, 2);
    final old = rows.firstWhere((r) => r.id == oldId);
    expect(old.active, isFalse);
    expect(old.deactivatedAt, isNotNull);
    final news = rows.where((r) => r.id != oldId).toList();
    expect(news, hasLength(1));
    expect(news.single.active, isTrue);
    expect(find.text('新电池'), findsOneWidget);
    await db.close();
  });

  testWidgets('编辑车辆保存后更新数据库与页面', (tester) async {
    final db = openNullDatabase();
    await db.into(db.vehicles).insert(VehiclesCompanion.insert(
          brand: '雅迪',
          model: 'DE3',
        ));
    await tester.pumpWidget(ProviderScope(
      overrides: [dbProvider.overrideWithValue(db)],
      child: const MaterialApp(home: VehicleScreen()),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('edit_vehicle')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('brand')), '新日');
    await tester.enterText(find.byKey(const Key('model')), 'XC2');
    await tester.tap(find.byKey(const Key('save')));
    await tester.pumpAndSettle();

    final v = (await db.select(db.vehicles).get()).single;
    expect(v.brand, '新日');
    expect(v.model, 'XC2');
    expect(find.text('新日 XC2'), findsOneWidget);
    await db.close();
  });

  testWidgets('名下有电池时删除车辆被拒绝', (tester) async {
    final db = openNullDatabase();
    await db.into(db.vehicles).insert(VehiclesCompanion.insert(
          brand: '雅迪',
          model: 'DE3',
        ));
    await db.into(db.batteries).insert(BatteriesCompanion.insert(
          vehicleId: 1,
          name: '原装',
          type: BatteryType.leadAcid,
          voltageV: 48,
          capacityAh: 20,
          installedAt: DateTime(2026, 1, 1),
        ));
    await tester.pumpWidget(ProviderScope(
      overrides: [dbProvider.overrideWithValue(db)],
      child: const MaterialApp(home: VehicleScreen()),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('delete_vehicle')));
    await tester.pumpAndSettle();

    expect(find.text('名下还有电池，无法删除'), findsOneWidget);
    expect(await db.select(db.vehicles).get(), hasLength(1));
    await db.close();
  });

  testWidgets('无电池车辆删除需确认并回到未设置状态', (tester) async {
    final db = openNullDatabase();
    await db.into(db.vehicles).insert(VehiclesCompanion.insert(
          brand: '雅迪',
          model: 'DE3',
        ));
    await tester.pumpWidget(ProviderScope(
      overrides: [dbProvider.overrideWithValue(db)],
      child: const MaterialApp(home: VehicleScreen()),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('delete_vehicle')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirm_delete_vehicle')));
    await tester.pumpAndSettle();

    expect(await db.select(db.vehicles).get(), isEmpty);
    expect(find.text('未设置车辆'), findsOneWidget);
    await db.close();
  });

  testWidgets('编辑电池更新名称与官方续航', (tester) async {
    final db = openNullDatabase();
    final batteryId = await db.into(db.batteries).insert(BatteriesCompanion.insert(
          vehicleId: 1,
          name: '原装',
          type: BatteryType.ternaryLithium,
          voltageV: 48,
          capacityAh: 20,
          installedAt: DateTime(2026, 1, 1),
        ));
    await tester.pumpWidget(ProviderScope(
      overrides: [dbProvider.overrideWithValue(db)],
      child: const MaterialApp(home: VehicleScreen()),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('edit_battery_$batteryId')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('battery_name')), '新电池');
    await tester.enterText(find.byKey(const Key('battery_range')), '80');
    await tester.tap(find.byKey(const Key('battery_save')));
    await tester.pumpAndSettle();

    final b = (await db.select(db.batteries).get()).single;
    expect(b.name, '新电池');
    expect(b.theoreticalRangeKm, 80);
    expect(find.text('新电池'), findsOneWidget);
    await db.close();
  });

  testWidgets('有充电记录的电池删除被拒绝', (tester) async {
    final db = openNullDatabase();
    final batteryId = await db.into(db.batteries).insert(BatteriesCompanion.insert(
          vehicleId: 1,
          name: '原装',
          type: BatteryType.ternaryLithium,
          voltageV: 48,
          capacityAh: 20,
          installedAt: DateTime(2026, 1, 1),
        ));
    await db.into(db.charges).insert(ChargesCompanion.insert(
          batteryId: batteryId,
          occurredAt: DateTime(2026, 2, 1),
          mode: ChargeMode.byTime,
          energyKwh: 0.51,
          energySource: EnergySource.powerTimesHours,
        ));
    await tester.pumpWidget(ProviderScope(
      overrides: [dbProvider.overrideWithValue(db)],
      child: const MaterialApp(home: VehicleScreen()),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('delete_battery_$batteryId')));
    await tester.pumpAndSettle();

    expect(find.text('该电池已有充电记录，仅可停用'), findsOneWidget);
    expect(await db.select(db.batteries).get(), hasLength(1));
    await db.close();
  });

  testWidgets('无记录电池删除需确认且生效', (tester) async {
    final db = openNullDatabase();
    final batteryId = await db.into(db.batteries).insert(BatteriesCompanion.insert(
          vehicleId: 1,
          name: '误建的电池',
          type: BatteryType.leadAcid,
          voltageV: 48,
          capacityAh: 12,
          installedAt: DateTime(2026, 1, 1),
        ));
    await tester.pumpWidget(ProviderScope(
      overrides: [dbProvider.overrideWithValue(db)],
      child: const MaterialApp(home: VehicleScreen()),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('delete_battery_$batteryId')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirm_delete_battery')));
    await tester.pumpAndSettle();

    expect(await db.select(db.batteries).get(), isEmpty);
    await db.close();
  });
}
