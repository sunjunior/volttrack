import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volttrack/data/providers.dart';
import 'package:volttrack/features/vehicle/vehicle_create_form.dart';
import '../helpers/test_db.dart';

void main() {
  testWidgets('必填项为空时拒绝保存', (tester) async {
    final db = openNullDatabase();
    await tester.pumpWidget(ProviderScope(
      overrides: [dbProvider.overrideWithValue(db)],
      child: const MaterialApp(home: VehicleCreateForm()),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save')));
    await tester.pumpAndSettle();

    final rows = await db.select(db.vehicles).get();
    expect(rows.length, 0);
    expect(find.text('请完整填写必填项'), findsOneWidget);
    await db.close();
  });

  testWidgets('填写品牌型号后保存写入车辆表并返回', (tester) async {
    final db = openNullDatabase();
    await tester.pumpWidget(ProviderScope(
      overrides: [dbProvider.overrideWithValue(db)],
      child: MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (_) => const VehicleCreateForm(), fullscreenDialog: true),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('brand')), '雅迪');
    await tester.enterText(find.byKey(const Key('model')), 'DE3');
    await tester.tap(find.byKey(const Key('save')));
    await tester.pumpAndSettle();

    final rows = await db.select(db.vehicles).get();
    expect(rows.length, 1);
    expect(rows.single.brand, '雅迪');
    expect(rows.single.model, 'DE3');
    expect(rows.single.initialMileageKm, 0.0);
    expect(find.byType(VehicleCreateForm), findsNothing);
    await db.close();
  });
}
