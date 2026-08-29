import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database.dart';
import 'repository.dart';
import 'tables.dart';
import '../core/engine/analytics.dart';
import '../core/models/charge.dart';

final dbProvider = Provider<AppDatabase>((ref) => openDatabase());
final repoProvider = Provider<AppRepository>((ref) => AppRepository(ref.watch(dbProvider)));

final chargesProvider = StreamProvider<List<ChargeRecord>>((ref) {
  final repo = ref.watch(repoProvider);
  return repo.watchCharges();
});

final activeBatteryProvider = StreamProvider<Battery?>((ref) {
  return ref.watch(repoProvider).activeBattery();
});

final analyticsProvider = Provider<AsyncValue<Analytics>>((ref) {
  final chargesAsync = ref.watch(chargesProvider);
  final batteryAsync = ref.watch(activeBatteryProvider);
  try {
    final charges = chargesAsync.value ?? const <ChargeRecord>[];
    final battery = batteryAsync.value;
    final capacity = battery == null
        ? 1.0
        : battery.overrideCapacityKwh ?? battery.voltageV * battery.capacityAh / 1000;
    return AsyncValue.data(computeAnalytics(
      charges: charges,
      capacityKwh: capacity,
      currentSocPct: null,
    ));
  } catch (err, stack) {
    return AsyncValue.error(err, stack);
  }
});