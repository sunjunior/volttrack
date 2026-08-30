import '../models/charge.dart';
import 'defaults.dart';

class EnergyResult {
  final double kwh;
  final EnergySource source;
  const EnergyResult(this.kwh, this.source);
}

EnergyResult deriveEnergyKwh({
  required ChargeMode mode,
  double? enteredKwh,
  double? moneyYuan,
  double? unitPriceYuanPerKwh,
  double? hours,
  double? powerW,
  int? socBeforePct,
  int? socAfterPct,
  double? capacityKwh,
  double efficiency = defaultChargingEfficiency,
}) {
  switch (mode) {
    case ChargeMode.byKwh:
      if (enteredKwh != null && enteredKwh > 0) {
        return EnergyResult(enteredKwh, EnergySource.manual);
      }
      if (moneyYuan != null && unitPriceYuanPerKwh != null && unitPriceYuanPerKwh > 0) {
        return EnergyResult(moneyYuan / unitPriceYuanPerKwh, EnergySource.amountOverUnitPrice);
      }
      break;
    case ChargeMode.byTime:
      if (socBeforePct != null &&
          socAfterPct != null &&
          capacityKwh != null &&
          socAfterPct > socBeforePct) {
        final delta = (socAfterPct - socBeforePct) / 100;
        return EnergyResult(capacityKwh * delta / efficiency, EnergySource.socDerived);
      }
      if (hours != null && powerW != null && hours > 0 && powerW > 0) {
        return EnergyResult(powerW * hours / 1000 * efficiency, EnergySource.powerTimesHours);
      }
      break;
    case ChargeMode.homeOutlet:
      if (socBeforePct != null && socAfterPct != null && capacityKwh != null && socAfterPct > socBeforePct) {
        final delta = (socAfterPct - socBeforePct) / 100;
        return EnergyResult(capacityKwh * delta / efficiency, EnergySource.socDerived);
      }
      if (enteredKwh != null && enteredKwh > 0) {
        return EnergyResult(enteredKwh, EnergySource.manual);
      }
      break;
  }
  throw ArgumentError('输入不足，无法推算充入度数');
}
