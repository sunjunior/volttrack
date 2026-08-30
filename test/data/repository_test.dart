import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volttrack/core/models/battery.dart';
import 'package:volttrack/core/models/charge.dart';
import 'package:volttrack/data/repository.dart';
import 'package:volttrack/data/tables.dart';

void main() {
  late AppDatabase db;
  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('车辆/电池/充电记录 CRUD 闭环', () async {
    final vehicleId = await db.into(db.vehicles).insert(VehiclesCompanion.insert(
      brand: '雅迪', model: 'DE3', initialMileageKm: Value(500.0),
    ));
    final batteryId = await db.into(db.batteries).insert(BatteriesCompanion.insert(
      vehicleId: vehicleId, name: '原装', type: BatteryType.ternaryLithium,
      voltageV: 48, capacityAh: 20, installedAt: DateTime(2026, 1, 1),
    ));
    await db.into(db.charges).insert(ChargesCompanion.insert(
      batteryId: batteryId, occurredAt: DateTime(2026, 2, 1),
      mode: ChargeMode.byTime, energyKwh: 0.51,
      energySource: EnergySource.manual,
      moneyYuan: Value(1), mileageKm: Value(1234.5),
    ));

    final rows = await db.select(db.charges).get();
    expect(rows.length, 1);
    expect(rows.first.energyKwh, 0.51);
    expect(rows.first.mileageKm, 1234.5);
  });

  test('Repository 映射与流：addCharge → watchCharges', () async {
    final repo = AppRepository(db);
    final batteryId = await db.into(db.batteries).insert(BatteriesCompanion.insert(
      vehicleId: 1, name: '原装', type: BatteryType.ternaryLithium,
      voltageV: 48, capacityAh: 20, installedAt: DateTime(2026, 1, 1),
    ));
    await repo.addCharge(c: ChargeRecord(
      id: 0, batteryId: batteryId, occurredAt: DateTime(2026, 2, 1, 8),
      mode: ChargeMode.byTime, energyKwh: 0.51,
      energySource: EnergySource.powerTimesHours,
      moneyYuan: 1, hours: 2, chargerPowerW: 300,
      priceDesc: '小区桩', socBeforePct: 30, socAfterPct: 100,
      mileageKm: 1234.5, note: '测试',
    ));

    final stream = repo.watchCharges();
    final first = await stream.first;
    expect(first.length, 1);
    final c = first.first;
    expect(c.energyKwh, 0.51);
    expect(c.energySource, EnergySource.powerTimesHours);
    expect(c.socBeforePct, 30);
    expect(c.mileageKm, 1234.5);
    expect(c.priceDesc, '小区桩');
    expect(c.note, '测试');
  });
}
