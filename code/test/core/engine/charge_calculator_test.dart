import 'package:flutter_test/flutter_test.dart';
import 'package:volttrack/core/engine/charge_calculator.dart';

void main() {
  test('按时长计费：进一取整到计费档', () {
    // 300W、0.79度、效率0.85，需充3.1h，2元/3小时 → 2档 → 4元
    final cost = costByTimeSlices(energyKwh: 0.79, powerW: 300, yuanPerSlice: 2, sliceHours: 3);
    expect(cost, closeTo(4, 0.001));
  });

  test('按度计费', () {
    expect(costByKwh(energyKwh: 0.96, yuanPerKwh: 0.8), closeTo(0.768, 0.001));
  });
}
