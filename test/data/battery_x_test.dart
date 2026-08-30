import 'package:flutter_test/flutter_test.dart';
import 'package:volttrack/core/models/battery.dart' show BatteryType;
import 'package:volttrack/data/battery_x.dart';
import 'package:volttrack/data/tables.dart';

Battery _row({double? overrideKwh, double voltage = 48, double ah = 20}) =>
    Battery(
      id: 1,
      vehicleId: 1,
      name: '原装',
      type: BatteryType.ternaryLithium,
      voltageV: voltage,
      capacityAh: ah,
      overrideCapacityKwh: overrideKwh,
      installedAt: DateTime(2026, 1, 1),
      active: true,
    );

void main() {
  test('capacityKwh 默认由电压×安时换算，覆盖值优先生效', () {
    expect(_row().capacityKwh, closeTo(0.96, 0.0001));
    expect(_row(overrideKwh: 1.1).capacityKwh, closeTo(1.1, 0.0001));
  });

  test('capacityKwh 非整值按公式计算', () {
    expect(_row(voltage: 48.5, ah: 20.25).capacityKwh, closeTo(0.982125, 0.0001));
  });

  test('specLabel 整值不带小数，非整值原样保留', () {
    expect(_row().specLabel, '48V20Ah');
    expect(_row(voltage: 48.5, ah: 20.25).specLabel, '48.5V20.25Ah');
  });
}
