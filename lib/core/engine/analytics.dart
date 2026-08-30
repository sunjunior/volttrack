import '../models/charge.dart';
import 'defaults.dart';
import 'energy_window.dart';

class Analytics {
  final List<ConsumptionWindow> windows;
  final int windowCount;
  final double? avgKwhPer100km;
  final double? avgYuanPerKm;
  final double totalEnergyKwh;
  final double totalCostYuan;
  final double? predictedRangeKm;

  const Analytics({
    required this.windows,
    required this.windowCount,
    required this.avgKwhPer100km,
    required this.avgYuanPerKm,
    required this.totalEnergyKwh,
    required this.totalCostYuan,
    required this.predictedRangeKm,
  });
}

Analytics computeAnalytics({
  required List<ChargeRecord> charges,
  required double capacityKwh,
  double? currentSocPct,
  List<ConsumptionWindow>? predefinedWindows,
}) {
  final windows = predefinedWindows ?? buildWindows(charges: charges, capacityKwh: capacityKwh);

  final totalEnergy = charges.fold<double>(0, (s, c) => s + c.energyKwh);
  final totalCost = charges.fold<double>(0, (s, c) => s + (c.moneyYuan ?? 0));
  final sumRide = windows.fold<double>(0, (s, w) => s + w.rideKwh);
  final sumDist = windows.fold<double>(0, (s, w) => s + w.distanceKm);
  final sumMoney = windows.fold<double>(0, (s, w) => s + w.moneyYuan);

  final avgKwh = sumDist > 0 ? sumRide / sumDist * 100 : null;
  final avgYuan = sumDist > 0 ? sumMoney / sumDist : null;

  double? predicted;
  if (avgKwh != null && avgKwh > 0 && currentSocPct != null && capacityKwh > 0) {
    predicted = currentSocPct / 100 * capacityKwh * rangeSafetyFactor / (avgKwh / 100);
  }

  return Analytics(
    windows: windows,
    windowCount: windows.length,
    avgKwhPer100km: avgKwh,
    avgYuanPerKm: avgYuan,
    totalEnergyKwh: totalEnergy,
    totalCostYuan: totalCost,
    predictedRangeKm: predicted,
  );
}
