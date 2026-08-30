import 'energy_window.dart';

/// SOH 估算：实际充入度数 ÷ 该段 SOC 区间对应的理论充入（容量×ΔSOC）。
/// 数据不足（range<=0）返回 null。
double? sohEstimate({
  required double energyKwh,
  required double capacityKwh,
  required int socBeforePct,
  required int socAfterPct,
}) {
  final range = (socAfterPct - socBeforePct) / 100;
  final theo = capacityKwh * range;
  if (range <= 0 || theo <= 0) return null;
  return (energyKwh / theo).clamp(0.0, 1.2);
}

/// 满电→低电 的窗口（用于跟踪满充里程是否衰减）。
/// 条件：起点充电后 socAfter>=90，终点到达 socBefore<=30。
List<ConsumptionWindow> fullRideWindows(List<ConsumptionWindow> windows) =>
    windows
        .where((w) => (w.start.socAfterPct ?? 0) >= 90 && (w.end.socBeforePct ?? 100) <= 30)
        .toList();

/// 实际平均续航 ÷ 官方/理论续航。
double? rangeAchievement({
  required List<ConsumptionWindow> fullRideWindows,
  double? theoreticalRangeKm,
}) {
  if (fullRideWindows.isEmpty || theoreticalRangeKm == null || theoreticalRangeKm <= 0) return null;
  final total = fullRideWindows.fold<double>(0, (s, w) => s + w.distanceKm);
  return (total / fullRideWindows.length) / theoreticalRangeKm;
}
