enum BatteryType { leadAcid, lifepo4, ternaryLithium }

class Battery {
  final int id;
  final int vehicleId;
  final String name;
  final BatteryType type;
  final double voltageV;
  final double capacityAh;
  final double? overrideCapacityKwh;
  final double? theoreticalRangeKm;
  final DateTime installedAt;
  final DateTime? deactivatedAt;
  final bool active;

  const Battery({
    this.id = 0,
    this.vehicleId = 1,
    required this.name,
    required this.type,
    required this.voltageV,
    required this.capacityAh,
    this.overrideCapacityKwh,
    this.theoreticalRangeKm,
    required this.installedAt,
    this.deactivatedAt,
    this.active = true,
  });

  double get capacityKwh => overrideCapacityKwh ?? voltageV * capacityAh / 1000;

  String get specLabel => '${_v(voltageV)}V${_a(capacityAh)}Ah';
  static String _v(double v) => v == v.roundToDouble() ? v.round().toString() : v.toString();
  static String _a(double a) => a == a.roundToDouble() ? a.round().toString() : a.toString();
}
