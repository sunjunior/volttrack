import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/battery.dart' show BatteryType;
import '../../data/providers.dart';
import '../../data/tables.dart';
import 'vehicle_form.dart';

class VehicleScreen extends ConsumerWidget {
  const VehicleScreen({super.key});

  static String typeLabel(BatteryType t) => switch (t) {
        BatteryType.leadAcid => '铅酸',
        BatteryType.lifepo4 => '磷酸铁锂',
        BatteryType.ternaryLithium => '三元锂',
      };

  static String _intValue(double v) =>
      v == v.roundToDouble() ? v.round().toString() : v.toString();

  static String specLabel(Battery b) =>
      '${_intValue(b.voltageV)}V${_intValue(b.capacityAh)}Ah';

  static double capacityKwh(Battery b) =>
      b.overrideCapacityKwh ?? b.voltageV * b.capacityAh / 1000;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.read(dbProvider);
    final batteryStream = ref.watch(repoProvider).watchBatteries();
    final activeId = ref.watch(activeBatteryProvider).value?.id;
    return Scaffold(
      appBar: AppBar(title: const Text('档案')),
      body: FutureBuilder<List<Vehicle>>(
        future: db.select(db.vehicles).get(),
        builder: (context, snap) {
          final rows = snap.data ?? const <Vehicle>[];
          final vehicle = rows.isEmpty ? null : rows.first;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _VehicleCard(vehicle: vehicle),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('电池组', style: Theme.of(context).textTheme.titleMedium),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                            builder: (_) => const VehicleForm()),
                      );
                    },
                    child: const Text('更换电池'),
                  ),
                ],
              ),
              StreamBuilder<List<Battery>>(
                stream: batteryStream,
                builder: (context, bSnap) {
                  final batteries = bSnap.data ?? const <Battery>[];
                  if (batteries.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text('还没有电池，点击更换电池添加'),
                    );
                  }
                  return Column(
                    children: [
                      for (final b in batteries)
                        _BatteryCard(
                          battery: b,
                          active: b.id == activeId,
                          typeLabel: typeLabel(b.type),
                          specLabel: specLabel(b),
                          capacityKwh: capacityKwh(b),
                        ),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  final Vehicle? vehicle;

  const _VehicleCard({this.vehicle});

  @override
  Widget build(BuildContext context) {
    final v = vehicle;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: v == null
            ? Text('未设置车辆', style: Theme.of(context).textTheme.bodyMedium)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${v.brand} ${v.model}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  if (v.purchaseDate != null)
                    Text('购入时间 ${_fmtDate(v.purchaseDate!)}'),
                  Text('初始里程 ${v.initialMileageKm.toStringAsFixed(1)} km'),
                ],
              ),
      ),
    );
  }
}

class _BatteryCard extends StatelessWidget {
  final Battery battery;
  final bool active;
  final String typeLabel;
  final String specLabel;
  final double capacityKwh;

  const _BatteryCard({
    required this.battery,
    required this.active,
    required this.typeLabel,
    required this.specLabel,
    required this.capacityKwh,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    battery.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 28),
                  child: Chip(
                    label: Text(active ? '当前生效' : '已停用'),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(typeLabel),
            Text(specLabel),
            Text('理论容量 ${capacityKwh.toStringAsFixed(2)} kWh'),
          ],
        ),
      ),
    );
  }
}

String _fmtDate(DateTime d) => '${d.year}-${_two(d.month)}-${_two(d.day)}';
String _two(int n) => n < 10 ? '0$n' : '$n';