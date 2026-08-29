import 'package:flutter_test/flutter_test.dart';
import 'package:volttrack/core/engine/analytics.dart';
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
}