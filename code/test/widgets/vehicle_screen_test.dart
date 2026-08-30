import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volttrack/core/models/battery.dart';
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
}
