import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volttrack/core/models/battery.dart';
import 'package:volttrack/core/models/charge.dart';
import 'package:volttrack/data/providers.dart';
import 'package:volttrack/data/tables.dart';
import 'package:volttrack/features/charging/charging_form.dart';
import '../helpers/test_db.dart';

void main() {
  testWidgets('无电池时保存被拒绝且不写库', (tester) async {
    final db = openNullDatabase();
    await tester.pumpWidget(ProviderScope(
      overrides: [dbProvider.overrideWithValue(db)],
      child: const MaterialApp(home: ChargingForm()),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('按时长'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('power_w')), '300');
    await tester.enterText(find.byKey(const Key('hours')), '2');
    await tester.pumpAndSettle();
    await tester.dragUntilVisible(
      find.byKey(const Key('save')),
      find.byKey(const Key('form_list')),
      const Offset(0, -200),
    );
    await tester.tap(find.byKey(const Key('save')));
    await tester.pumpAndSettle();

    final rows = await db.select(db.charges).get();
    expect(rows.length, 0);
    expect(find.text('请先在档案页添加电池'), findsOneWidget);
    expect(find.text('已记录'), findsNothing);
    await db.close();
  });

  testWidgets('空输入时保存被拒绝且提示计费信息', (tester) async {
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
      child: const MaterialApp(home: ChargingForm()),
    ));
    await tester.pumpAndSettle();
    await tester.dragUntilVisible(
      find.byKey(const Key('save')),
      find.byKey(const Key('form_list')),
      const Offset(0, -200),
    );
    await tester.tap(find.byKey(const Key('save')));
    await tester.pumpAndSettle();

    final rows = await db.select(db.charges).get();
    expect(rows.length, 0);
    expect(find.text('请完整填写当前模式的计费信息'), findsOneWidget);
    expect(find.text('已记录'), findsNothing);
    await db.close();
  });

  testWidgets('按时长模式实时预览度数', (tester) async {
    final db = openNullDatabase();
    await tester.pumpWidget(ProviderScope(
      overrides: [dbProvider.overrideWithValue(db)],
      child: const MaterialApp(home: ChargingForm()),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('按时长'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('power_w')), '300');
    await tester.enterText(find.byKey(const Key('hours')), '2');
    await tester.pumpAndSettle();
    expect(find.text('0.51 kWh'), findsOneWidget);
    await db.close();
  });

  testWidgets('按时长模式可记录金额', (tester) async {
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
      child: const MaterialApp(home: ChargingForm()),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('按时长'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('power_w')), '300');
    await tester.enterText(find.byKey(const Key('hours')), '2');
    await tester.enterText(find.byKey(const Key('money')), '2');
    await tester.pumpAndSettle();
    await tester.dragUntilVisible(
      find.byKey(const Key('save')),
      find.byType(ListView),
      const Offset(0, -150),
    );
    await tester.pumpAndSettle();
    await tester.dragUntilVisible(
      find.byKey(const Key('save')),
      find.byKey(const Key('form_list')),
      const Offset(0, -200),
    );
    await tester.tap(find.byKey(const Key('save')));
    await tester.pumpAndSettle();

    final rows = await db.select(db.charges).get();
    expect(rows.length, 1);
    expect(rows.single.moneyYuan, 2);
    expect(find.text('已记录'), findsOneWidget);
    await db.close();
  });

  testWidgets('插座模式可记录金额', (tester) async {
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
      child: const MaterialApp(home: ChargingForm()),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('插座'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('soc_before')), '20');
    await tester.enterText(find.byKey(const Key('soc_after')), '80');
    await tester.enterText(find.byKey(const Key('money')), '3');
    await tester.pumpAndSettle();
    await tester.dragUntilVisible(
      find.byKey(const Key('save')),
      find.byType(ListView),
      const Offset(0, -150),
    );
    await tester.pumpAndSettle();
    await tester.dragUntilVisible(
      find.byKey(const Key('save')),
      find.byKey(const Key('form_list')),
      const Offset(0, -200),
    );
    await tester.tap(find.byKey(const Key('save')));
    await tester.pumpAndSettle();

    final rows = await db.select(db.charges).get();
    expect(rows.length, 1);
    expect(rows.single.moneyYuan, 3);
    await db.close();
  });

  testWidgets('保存后记录写入数据库并提示已记录', (tester) async {
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
      child: const MaterialApp(home: ChargingForm()),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('按时长'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('power_w')), '300');
    await tester.enterText(find.byKey(const Key('hours')), '2');
    await tester.pumpAndSettle();
    await tester.dragUntilVisible(
      find.byKey(const Key('save')),
      find.byKey(const Key('form_list')),
      const Offset(0, -200),
    );
    await tester.tap(find.byKey(const Key('save')));
    await tester.pumpAndSettle();

    final rows = await db.select(db.charges).get();
    expect(rows.length, 1);
    expect(rows.first.energyKwh, 0.51);
    expect(find.text('已记录'), findsOneWidget);
    await db.close();
  });

  testWidgets('按时长模式：仅填前后 SOC 即可预览反推度数', (tester) async {
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
      child: const MaterialApp(home: ChargingForm()),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('按时长'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('soc_before')), '30');
    await tester.enterText(find.byKey(const Key('soc_after')), '100');
    await tester.pumpAndSettle();

    expect(find.text('0.79 kWh'), findsOneWidget);
    await db.close();
  });

  testWidgets('按时长模式：SOC 反推保存为 socDerived 且 SOC 落库', (tester) async {
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
      child: const MaterialApp(home: ChargingForm()),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('按时长'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('soc_before')), '30');
    await tester.enterText(find.byKey(const Key('soc_after')), '100');
    await tester.enterText(find.byKey(const Key('money')), '2');
    await tester.pumpAndSettle();
    await tester.dragUntilVisible(
      find.byKey(const Key('save')),
      find.byKey(const Key('form_list')),
      const Offset(0, -200),
    );
    await tester.tap(find.byKey(const Key('save')));
    await tester.pumpAndSettle();

    final rows = await db.select(db.charges).get();
    expect(rows.length, 1);
    expect(rows.single.energySource, EnergySource.socDerived);
    expect(rows.single.energyKwh, closeTo(0.791, 0.001));
    expect(rows.single.socBeforePct, 30);
    expect(rows.single.socAfterPct, 100);
    expect(rows.single.moneyYuan, 2);
    expect(find.text('已记录'), findsOneWidget);
    await db.close();
  });
}
