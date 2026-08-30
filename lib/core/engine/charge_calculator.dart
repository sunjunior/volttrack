import 'defaults.dart';

class ChargingOption {
  final String name;
  final double Function(double energyKwh) costOf;
  const ChargingOption(this.name, this.costOf);
}

/// 按时长计费（小区桩）：需充时长÷单档时长 向上取整 × 单价。
double costByTimeSlices({
  required double energyKwh,
  required double powerW,
  required double yuanPerSlice,
  required double sliceHours,
  double efficiency = defaultChargingEfficiency,
}) {
  final hours = energyKwh * 1000 / powerW / efficiency;
  final slices = (hours / sliceHours).ceil();
  return slices * yuanPerSlice;
}

double costByKwh({required double energyKwh, required double yuanPerKwh}) =>
    energyKwh * yuanPerKwh;

/// 同充满目标度数下比较多个方案的月度/单次成本，返回最省钱下标。
int cheapestOption(List<ChargingOption> options, double energyKwh) {
  final costs = [for (final o in options) o.costOf(energyKwh)];
  var best = 0;
  for (var i = 1; i < costs.length; i++) {
    if (costs[i] < costs[best]) best = i;
  }
  return best;
}
