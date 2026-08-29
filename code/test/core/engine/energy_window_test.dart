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

  test('区间无充电但到达 SOC 抬升 → ride<0 → unusual=true', () {
    // 手算：起点到达 SOC 45、终点到达 SOC 100，区间充入 0 度，C=0.96。
    // ΔSOC = 0.96×(100−45)/100 = +0.528；ride = 0 − 0.528 = −0.528 < 0。
    // 距离 1040−1000 = 40km；kwhPer100 = −0.528/40*100 = −1.32（非 >6 分支）。
    final windows = buildWindows(
      charges: [
        rec(1, DateTime(2026, 1, 1, 8), sBefore: 45, mileage: 1000),
        rec(2, DateTime(2026, 1, 2, 8), sBefore: 100, mileage: 1040),
      ],
      capacityKwh: 0.96,
    );
    final w = windows.first;
    expect(w.energyInKwh, 0);
    expect(w.deltaSocKwh, closeTo(0.528, 0.0001));
    expect(w.rideKwh, closeTo(-0.528, 0.0001));
    expect(w.rideKwh, lessThan(0));
    expect(w.unusual, isTrue);
  });

  test('短距离高充入 → kwhPer100>6 → unusual=true', () {
    // 手算：两锚点到达 SOC 相同（50），区间充入 1.0 度，距离 10km。
    // ΔSOC = 0；ride = 1.0；kwhPer100 = 1.0/10*100 = 10 > 6。
    final windows = buildWindows(
      charges: [
        rec(1, DateTime(2026, 1, 1, 8), sBefore: 50, mileage: 1000),
        rec(2, DateTime(2026, 1, 1, 12), energy: 1.0, sBefore: 50),
        rec(3, DateTime(2026, 1, 2, 8), sBefore: 50, mileage: 1010),
      ],
      capacityKwh: 0.96,
    );
    final w = windows.first;
    expect(w.rideKwh, closeTo(1.0, 0.0001));
    expect(w.kwhPer100km, closeTo(10.0, 0.001));
    expect(w.kwhPer100km, greaterThan(6));
    expect(w.unusual, isTrue);
  });

  test('边界 kwhPer100 == 6.0 → unusual=false', () {
    // 手算：区间充入 0.6 度，距离 10km，SOC 相同 → kwhPer100 = 0.6/10*100 = 6.0。
    // 实现用严格大于（ride<0 || kwhPer100>6），恰好 6.0 不标记 unusual。
    final windows = buildWindows(
      charges: [
        rec(1, DateTime(2026, 1, 1, 8), sBefore: 50, mileage: 1000),
        rec(2, DateTime(2026, 1, 1, 12), energy: 0.6, sBefore: 50),
        rec(3, DateTime(2026, 1, 2, 8), sBefore: 50, mileage: 1010),
      ],
      capacityKwh: 0.96,
    );
    final w = windows.first;
    expect(w.kwhPer100km, closeTo(6.0, 1e-9));
    expect(w.unusual, isFalse);
  });
}
