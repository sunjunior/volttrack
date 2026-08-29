import 'package:flutter_test/flutter_test.dart';
import 'package:volttrack/core/models/battery.dart';
import 'package:volttrack/core/models/charge.dart';

void main() {
  test('Battery.capacityKwh 由电压×安时自动计算，可被手动覆盖', () {
    final b = Battery(
      id: 1, vehicleId: 1, name: '原装电池', type: BatteryType.ternaryLithium,
      voltageV: 48, capacityAh: 20, overrideCapacityKwh: null,
      installedAt: DateTime(2026, 1, 1),
    );
    expect(b.capacityKwh, closeTo(0.96, 0.001));
    final overridden = Battery(
      id: 2, vehicleId: 1, name: '改装', type: BatteryType.lifepo4,
      voltageV: 60, capacityAh: 20, overrideCapacityKwh: 1.1,
      installedAt: DateTime(2026, 1, 1),
    );
    expect(overridden.capacityKwh, closeTo(1.1, 0.001));
  });

  test('ChargeRecord 构造含全部核心字段', () {
    final c = ChargeRecord(
      id: 1, batteryId: 1, occurredAt: DateTime(2026, 2, 1),
      mode: ChargeMode.byTime, energyKwh: 0.51, energySource: EnergySource.powerTimesHours,
      moneyYuan: 1, hours: 2, chargerPowerW: 300, priceDesc: '1元/2小时',
      socBeforePct: 60, socAfterPct: 85, mileageKm: 1200.5,
    );
    expect(c.mode, ChargeMode.byTime);
    expect(c.energyKwh, 0.51);
    expect(c.mileageKm, 1200.5);
  });
}