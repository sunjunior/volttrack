import 'package:flutter_test/flutter_test.dart';
import 'package:volttrack/core/engine/energy_window.dart';
import 'package:volttrack/core/models/charge.dart';

ChargeRecord rec(int id, DateTime t,
    {double energy = 0, double money = 0, int? sBefore, int? sAfter, double? mileage}) {
  return ChargeRecord(
    id: id, batteryId: 1, occurredAt: t, mode: ChargeMode.byTime,
    energyKwh: energy, energySource: EnergySource.manual, moneyYuan: money,
    socBeforePct: sBefore, socAfterPct: sAfter, mileageKm: mileage,
  );
}

void main() {
  // 场景（与设计文档样例一致）：1000km 时充电 0.72 度（SOC 30→100），
  // 骑到 1060km 剩 45%（作为下一段里程的到达 SOC）。
  final charges = [
    rec(1, DateTime(2026, 1, 1, 8), energy: 0.72, sBefore: 30, sAfter: 100, mileage: 1000),
    rec(2, DateTime(2026, 1, 2, 8), sBefore: 45, mileage: 1060),
  ];

  test('窗口电耗 = Σ[tA,tB) 充入度数 − C×ΔSOC(到达−到达)', () {
    final windows = buildWindows(charges: charges, capacityKwh: 0.96);
    expect(windows.length, 1);
    final w = windows.first;
    expect(w.energyInKwh, 0.72);
    expect(w.deltaSocKwh, closeTo(0.96 * (45 - 30) / 100, 0.0001)); // +0.144
    expect(w.rideKwh, closeTo(0.72 - 0.144, 0.0001));               // 0.576
    expect(w.distanceKm, 60);
    expect(w.kwhPer100km, closeTo(0.96, 0.001));                    // 0.576/60*100
    expect(w.yuanPerKm, 0);
    expect(w.corrected, isTrue);
  });

  test('里程未增加的记录不构成窗口', () {
    final c2 = rec(2, DateTime(2026, 1, 1, 9), energy: 0.72, sBefore: 30, mileage: 1000);
    final windows = buildWindows(charges: [rec(1, DateTime(2026, 1, 1, 8), mileage: 1000), c2],
        capacityKwh: 0.96);
    expect(windows, isEmpty);
  });

  test('无 SOC 时退化为仅按充入度数（corrected=false）', () {
    // 中间纯充电记录（无里程）计入窗口；终点锚点的充电归属下一段，不计入。
    final windows = buildWindows(
      charges: [
        rec(1, DateTime(2026, 1, 1, 8), mileage: 1000),
        rec(2, DateTime(2026, 1, 1, 12), energy: 1.1, money: 1.1),
        rec(3, DateTime(2026, 1, 2, 8), money: 2, mileage: 1100),
      ],
      capacityKwh: 0.96,
    );
    final w = windows.first;
    expect(w.corrected, isFalse);
    expect(w.kwhPer100km, closeTo(1.1, 0.001));
    expect(w.yuanPerKm, closeTo(1.1 / 100, 0.001));
  });
}
