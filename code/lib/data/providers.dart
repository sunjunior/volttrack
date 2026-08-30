import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'battery_x.dart';
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

int? _latestSocAfterPct(List<ChargeRecord> charges) {
  for (final c in charges) {
    final soc = c.socAfterPct;
    if (soc != null) return soc;
  }
  return null;
}

final analyticsProvider = Provider<AsyncValue<Analytics>>((ref) {
  final chargesAsync = ref.watch(chargesProvider);
  final batteryAsync = ref.watch(activeBatteryProvider);
  try {
    final allCharges = chargesAsync.value ?? const <ChargeRecord>[];
    final battery = batteryAsync.value;
    final charges = battery == null
        ? allCharges
        : allCharges.where((c) => c.batteryId == battery.id).toList();
    final capacity = battery?.capacityKwh;
    return AsyncValue.data(computeAnalytics(
      charges: charges,
      capacityKwh: capacity ?? 1.0,
      currentSocPct: _latestSocAfterPct(charges)?.toDouble(),
    ));
  } catch (err, stack) {
    return AsyncValue.error(err, stack);
  }
});