enum ChargeMode { byKwh, byTime, homeOutlet }

enum EnergySource { manual, amountOverUnitPrice, powerTimesHours, socDerived }

class ChargeRecord {
  final int id;
  final int batteryId;
  final DateTime occurredAt;
  final ChargeMode mode;
  final double energyKwh;
  final EnergySource energySource;
  final double? moneyYuan;
  final double? hours;
  final double? chargerPowerW;
  final String? priceDesc;
  final int? socBeforePct;
  final int? socAfterPct;
  final double? mileageKm;
  final String? note;

  const ChargeRecord({
    this.id = 0,
    this.batteryId = 1,
    required this.occurredAt,
    required this.mode,
    required this.energyKwh,
    required this.energySource,
    this.moneyYuan,
    this.hours,
    this.chargerPowerW,
    this.priceDesc,
    this.socBeforePct,
    this.socAfterPct,
    this.mileageKm,
    this.note,
  });
}
