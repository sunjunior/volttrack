import 'package:flutter_test/flutter_test.dart';
import 'package:volttrack/core/engine/analytics.dart';
import 'package:volttrack/core/engine/energy_window.dart';
import 'package:volttrack/core/models/charge.dart';

ChargeRecord mrec(int id, DateTime t, {double e = 0, double m = 0, int? sb, int? sa, double? km}) =>
    ChargeRecord(id: id, batteryId: 1, occurredAt: t, mode: ChargeMode.byTime,
        energyKwh: e, energySource: EnergySource.manual, moneyYuan: m,
        socBeforePct: sb, socAfterPct: sa, mileageKm: km);

void main() {
  final charges = [
    mrec(1, DateTime(2026, 1, 1), sa: 100, km: 1000),
    mrec(2, DateTime(2026, 1, 1, 1), e: 1.0, m: 1.0),
    mrec(3, DateTime(2026, 1, 2), sb: 100, km: 1100),
    mrec(4, DateTime(2026, 1, 3), sa: 90, km: 1200),
  ];

  test('距离加权百公里电耗、每公里成本与累计开销', () {
    final a = computeAnalytics(charges: charges, capacityKwh: 0.96);
    expect(a.totalEnergyKwh, closeTo(1.0, 0.0001));
    expect(a.totalCostYuan, closeTo(1.0, 0.0001));
    // 窗1: 1000→1100, [t1,t2) 内充1度(纯充电记录), 起点锚点无SOC → 不校正 E=1.0
    // 窗2: 1100→1200, 区间无充电 → E=0。加权 = (1.0+0)/(200)*100 = 0.5
    expect(a.avgKwhPer100km, closeTo(0.5, 0.001)); // 1.0/(200)*100
    expect(a.avgYuanPerKm, closeTo(0.005, 0.001)); // 1.0/200
  });

  test('当前电量下续航预测', () {
    final a = computeAnalytics(charges: charges, capacityKwh: 0.96, currentSocPct: 50);
    // 0.50×0.96×0.9 ÷ (0.5/100) = 86.4
    expect(a.predictedRangeKm, closeTo(86.4, 0.1));
  });

  test('距离加权口径用不等距窗口区分两种计算', () {
    // 不等距: 窗A 距离200 充1度; 窗B 距离100 无充电
    // Σ/Σ = 1.0/300×100 = 0.3333，而两窗 kwhPer100 的算术平均 = (0.5+0)/2 = 0.25
    final uneq = [
      mrec(1, DateTime(2026, 2, 1), sa: 100, km: 1000),
      mrec(2, DateTime(2026, 2, 1, 1), e: 1.0, m: 1.0),
      mrec(3, DateTime(2026, 2, 2), sa: 100, km: 1200),
      mrec(4, DateTime(2026, 2, 3), sa: 90, km: 1300),
    ];
    final a = computeAnalytics(charges: uneq, capacityKwh: 0.96);
    expect(a.windowCount, 2);
    expect(a.windows[0].distanceKm, closeTo(200, 0.001));
    expect(a.windows[1].distanceKm, closeTo(100, 0.001));
    // 加权口径: Σride/Σdist；若误用算术平均会是 0.25
    expect(a.avgKwhPer100km, closeTo(0.3333, 0.001));
    expect(a.avgYuanPerKm, closeTo(0.003333, 0.0001));
  });

  test('predefinedWindows 分支按注入窗口计算', () {
    final win = ConsumptionWindow(
      start: mrec(1, DateTime(2026, 3, 1), km: 2000),
      end: mrec(2, DateTime(2026, 3, 1, 1), km: 2200),
      energyInKwh: 4.0,
      moneyYuan: 8.0,
      deltaSocKwh: 2.0,
      rideKwh: 2.0,
      distanceKm: 200,
      kwhPer100km: 1.0,
      yuanPerKm: 0.04,
      corrected: true,
      unusual: false,
    );
    final a = computeAnalytics(
      charges: charges,
      capacityKwh: 0.96,
      predefinedWindows: [win],
    );
    expect(a.windowCount, 1);
    expect(identical(a.windows.single, win), isTrue);
    // Σride=2.0, Σdist=200 → 2.0/200×100 = 1.0
    expect(a.avgKwhPer100km, closeTo(1.0, 0.0001));
    expect(a.avgYuanPerKm, closeTo(0.04, 0.0001));
  });

  test('窗外记录计入总耗与总费,不影响窗口口径', () {
    final extended = [
      ...charges,
      mrec(5, DateTime(2026, 1, 4), e: 5.0, m: 10.0),
    ];
    final a = computeAnalytics(charges: extended, capacityKwh: 0.96);
    // 落在所有窗口之后的纯充电记录 → 计入 fold-all 总量
    expect(a.totalEnergyKwh, closeTo(6.0, 0.0001));
    expect(a.totalCostYuan, closeTo(11.0, 0.0001));
    // 窗外记录不进入任何窗口 → 距离加权口径不变
    expect(a.avgKwhPer100km, closeTo(0.5, 0.001));
  });

  test('predictedRangeKm 缺省或零耗电时为 null', () {
    expect(computeAnalytics(charges: charges, capacityKwh: 0.96).predictedRangeKm, isNull);
    final noRide = [
      mrec(1, DateTime(2026, 4, 1), sa: 100, km: 5000),
      mrec(2, DateTime(2026, 4, 2), sa: 100, km: 5100),
    ];
    final a = computeAnalytics(charges: noRide, capacityKwh: 0.96, currentSocPct: 50);
    expect(a.avgKwhPer100km, closeTo(0.0, 0.0001)); // Σdist>0 且 Σride=0 → avgKwh=0
    expect(a.predictedRangeKm, isNull); // avgKwh>0 不成立 → 返回 null
  });
}