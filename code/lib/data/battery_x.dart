import 'tables.dart';

extension BatteryX on Battery {
  /// 生效容量：覆盖值优先，否则按 标称电压×安时/1000 换算。
  double get capacityKwh => overrideCapacityKwh ?? voltageV * capacityAh / 1000;

  /// 规格文案：整值不带小数，如 48V20Ah；非整值原样保留，如 48.5V20.25Ah。
  String get specLabel => '${_intValue(voltageV)}V${_intValue(capacityAh)}Ah';
}

String _intValue(double v) =>
    v == v.roundToDouble() ? v.round().toString() : v.toString();
