import 'package:flutter_test/flutter_test.dart';
import 'package:volttrack/core/engine/energy_derivation.dart';
import 'package:volttrack/core/models/charge.dart';

void main() {
  test('按时长充：功率(W)×时长(h)/1000×效率', () {
    final r = deriveEnergyKwh(
      mode: ChargeMode.byTime, hours: 2, powerW: 300, efficiency: 0.85,
    );
    expect(r.kwh, closeTo(0.51, 0.0001));
    expect(r.source, EnergySource.powerTimesHours);
  });

  test('按时长：有前后 SOC 时优先反推度数', () {
    final r = deriveEnergyKwh(
      mode: ChargeMode.byTime, hours: 2, powerW: 300,
      socBeforePct: 30, socAfterPct: 100, capacityKwh: 0.96, efficiency: 0.85,
    );
    expect(r.kwh, closeTo(0.791, 0.001));
    expect(r.source, EnergySource.socDerived);
  });

  test('按度/金额：金额÷单价推出度数', () {
    final r = deriveEnergyKwh(
      mode: ChargeMode.byKwh, moneyYuan: 1.6, unitPriceYuanPerKwh: 0.8,
    );
    expect(r.kwh, closeTo(2.0, 0.0001));
  });

  test('按度/金额：手输度数优先于金额推算', () {
    final r = deriveEnergyKwh(
      mode: ChargeMode.byKwh, enteredKwh: 1.5, moneyYuan: 1.6, unitPriceYuanPerKwh: 0.8,
    );
    expect(r.source, EnergySource.manual);
    expect(r.kwh, 1.5);
  });

  test('家用插座：ΔSOC×容量÷效率 反推', () {
    final r = deriveEnergyKwh(
      mode: ChargeMode.homeOutlet, socBeforePct: 30, socAfterPct: 100,
      capacityKwh: 0.96, efficiency: 0.85,
    );
    expect(r.kwh, closeTo(0.791, 0.001));
    expect(r.source, EnergySource.socDerived);
  });

  test('无可推算依据时报错', () {
    expect(() => deriveEnergyKwh(mode: ChargeMode.byKwh), throwsArgumentError);
  });
}
