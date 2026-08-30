import 'package:drift/drift.dart' hide isNotNull;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volttrack/core/models/battery.dart';
import 'package:volttrack/core/models/charge.dart';
import 'package:volttrack/data/providers.dart';
import 'package:volttrack/data/tables.dart';
import '../helpers/test_db.dart';

void main() {
  test('analyticsProvider 用最近一次充后 SOC 预估续航', () async {
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
          occurredAt: DateTime(2026, 1, 1, 8),
          mode: ChargeMode.byTime,
          energyKwh: 0.72,
          energySource: EnergySource.manual,
          socBeforePct: const Value(30),
          socAfterPct: const Value(100),
          mileageKm: const Value(1000),
        ));
    await db.into(db.charges).insert(ChargesCompanion.insert(
          batteryId: 1,
          occurredAt: DateTime(2026, 1, 2, 8),
          mode: ChargeMode.byTime,
          energyKwh: 0,
          energySource: EnergySource.manual,
          socBeforePct: const Value(45),
          mileageKm: const Value(1060),
        ));

    final container =
        ProviderContainer(overrides: [dbProvider.overrideWithValue(db)]);
    await container.read(chargesProvider.future);
    await container.read(activeBatteryProvider.future);

    final analytics = container.read(analyticsProvider).requireValue;
    expect(analytics.predictedRangeKm, isNotNull);
    expect(analytics.predictedRangeKm, closeTo(90, 0.5));

    container.dispose();
    await db.close();
  });
}
