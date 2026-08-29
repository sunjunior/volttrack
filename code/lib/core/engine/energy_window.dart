import '../models/charge.dart';

class ConsumptionWindow {
  final ChargeRecord start;
  final ChargeRecord end;
  final double energyInKwh;
  final double moneyYuan;
  final double deltaSocKwh;
  final double rideKwh;
  final double distanceKm;
  final double kwhPer100km;
  final double yuanPerKm;
  final bool corrected;
  final bool unusual;

  const ConsumptionWindow({
    required this.start,
    required this.end,
    required this.energyInKwh,
    required this.moneyYuan,
    required this.deltaSocKwh,
    required this.rideKwh,
    required this.distanceKm,
    required this.kwhPer100km,
    required this.yuanPerKm,
    required this.corrected,
    required this.unusual,
  });
}

/// 按时间排序的锚点记录两两成窗。区间耗电 = 区间充入度数 − C×(到达SOC_B − 到达SOC_A)。
/// 区间取 [t_A, t_B)：起点锚点的充电计入，终点锚点的充电归入下一窗口。
/// 两个锚点都有 socBeforePct 才启用 ΔSOC 校正。
List<ConsumptionWindow> buildWindows({
  required List<ChargeRecord> charges,
  required double capacityKwh,
}) {
  final sorted = [...charges]..sort((a, b) => a.occurredAt.compareTo(b.occurredAt));
  final anchors = sorted.where((c) => c.mileageKm != null).toList();
  final windows = <ConsumptionWindow>[];

  for (var i = 0; i + 1 < anchors.length; i++) {
    final a = anchors[i];
    final b = anchors[i + 1];
    if (b.mileageKm! <= a.mileageKm!) continue;

    var energy = 0.0;
    var money = 0.0;
    for (final c in sorted) {
      if (!c.occurredAt.isBefore(a.occurredAt) && c.occurredAt.isBefore(b.occurredAt)) {
        energy += c.energyKwh;
        money += c.moneyYuan ?? 0;
      }
    }

    final startSoc = a.socBeforePct;
    final endSoc = b.socBeforePct;
    final corrected = startSoc != null && endSoc != null;
    final deltaSoc = corrected ? capacityKwh * (endSoc - startSoc) / 100 : 0.0;
    final ride = energy - deltaSoc;
    final distance = b.mileageKm! - a.mileageKm!;
    final kwhPer100 = ride / distance * 100;

    windows.add(ConsumptionWindow(
      start: a,
      end: b,
      energyInKwh: energy,
      moneyYuan: money,
      deltaSocKwh: deltaSoc,
      rideKwh: ride,
      distanceKm: distance,
      kwhPer100km: kwhPer100,
      yuanPerKm: money / distance,
      corrected: corrected,
      unusual: ride < 0 || kwhPer100 > 6,
    ));
  }
  return windows;
}
