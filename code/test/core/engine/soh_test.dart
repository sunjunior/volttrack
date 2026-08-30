import 'package:flutter_test/flutter_test.dart';
import 'package:volttrack/core/engine/energy_window.dart';
import 'package:volttrack/core/engine/soh.dart';
import 'package:volttrack/core/models/charge.dart';

void main() {
  test('满充事件 SOH：实际充入÷理论充入', () {
    final soh = sohEstimate(energyKwh: 0.9, capacityKwh: 1.0, socBeforePct: 5, socAfterPct: 100);
    expect(soh, closeTo(0.947, 0.001));
    expect(sohEstimate(energyKwh: 0.5, capacityKwh: 1.0, socBeforePct: 90, socAfterPct: 90), isNull);
  });

  test('达成率：满充→低电窗口均距 ÷ 理论续航', () {
    ChargeRecord r(int id, int after, double km, {int? before}) => ChargeRecord(
      id: id, batteryId: 1, occurredAt: DateTime(2026, 1, 1),
      mode: ChargeMode.byTime, energyKwh: 0, energySource: EnergySource.manual,
      socBeforePct: before, socAfterPct: after, mileageKm: km,
    );
    final windows = [
      ConsumptionWindow(start: r(1, 100, 1000), end: r(1, 50, 1070, before: 30),
        energyInKwh: 0.9, moneyYuan: 1, deltaSocKwh: 0, rideKwh: 0.9,
        distanceKm: 70, kwhPer100km: 1.28, yuanPerKm: 0.014, corrected: true, unusual: false),
    ];
    expect(fullRideWindows(windows).length, 1);
    final ach = rangeAchievement(fullRideWindows: windows, theoreticalRangeKm: 80);
    expect(ach, closeTo(0.875, 0.001));
    expect(rangeAchievement(fullRideWindows: windows, theoreticalRangeKm: null), isNull);
  });
}
