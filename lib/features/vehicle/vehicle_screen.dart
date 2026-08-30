import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/battery.dart' show BatteryType;
import '../../data/battery_x.dart';
import '../../data/providers.dart';
import '../../data/tables.dart';
import 'vehicle_create_form.dart';
import 'vehicle_form.dart';

class VehicleScreen extends ConsumerWidget {
  const VehicleScreen({super.key});

  static String typeLabel(BatteryType t) => switch (t) {
        BatteryType.leadAcid => '铅酸',
        BatteryType.lifepo4 => '磷酸铁锂',
        BatteryType.ternaryLithium => '三元锂',
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.read(dbProvider);
    final batteryStream = ref.watch(repoProvider).watchBatteries();
    final activeId = ref.watch(activeBatteryProvider).value?.id;
    return Scaffold(
      appBar: AppBar(title: const Text('档案')),
      body: StreamBuilder<List<Vehicle>>(
        stream: db.select(db.vehicles).watch(),
        builder: (context, snap) {
          final rows = snap.data ?? const <Vehicle>[];
          final vehicle = rows.isEmpty ? null : rows.first;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _VehicleCard(
                vehicle: vehicle,
                onEdit: vehicle == null
                    ? null
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                              builder: (_) =>
                                  VehicleCreateForm(existing: vehicle)),
                        );
                      },
                onDelete: vehicle == null
                    ? null
                    : () => _deleteVehicle(context, ref, vehicle),
              ),
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
                          specLabel: b.specLabel,
                          capacityKwh: b.capacityKwh,
                          onEdit: () => _editBattery(context, ref, b),
                          onDelete: () => _deleteBattery(context, ref, b),
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
  Future<void> _deleteVehicle(
      BuildContext context, WidgetRef ref, Vehicle v) async {
    final db = ref.read(dbProvider);
    final batteries = await (db.select(db.batteries)
          ..where((t) => t.vehicleId.equals(v.id)))
        .get();
    if (!context.mounted) return;
    if (batteries.isNotEmpty) {
      _toast(context, '名下还有电池，无法删除');
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除这辆车？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            key: const Key('confirm_delete_vehicle'),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('删除'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await (db.delete(db.vehicles)..where((t) => t.id.equals(v.id))).go();
    }
  }

  Future<void> _editBattery(
      BuildContext context, WidgetRef ref, Battery b) async {
    final result = await showDialog<_BatteryEditResult>(
      context: context,
      builder: (ctx) => _BatteryEditDialog(battery: b),
    );
    if (result == null) return;
    final db = ref.read(dbProvider);
    await (db.update(db.batteries)..where((t) => t.id.equals(b.id)))
        .write(BatteriesCompanion(
      name: Value(result.name),
      theoreticalRangeKm: Value(result.theoreticalRangeKm),
      overrideCapacityKwh: Value(result.overrideCapacityKwh),
    ));
  }

  Future<void> _deleteBattery(
      BuildContext context, WidgetRef ref, Battery b) async {
    final db = ref.read(dbProvider);
    final charges = await (db.select(db.charges)
          ..where((t) => t.batteryId.equals(b.id)))
        .get();
    if (!context.mounted) return;
    if (charges.isNotEmpty) {
      _toast(context, '该电池已有充电记录，仅可停用');
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('删除电池「${b.name}」？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            key: const Key('confirm_delete_battery'),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('删除'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await (db.delete(db.batteries)..where((t) => t.id.equals(b.id))).go();
    }
  }

  void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  final Vehicle? vehicle;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _VehicleCard({this.vehicle, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final v = vehicle;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: v == null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('未设置车辆',
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    key: const Key('add_vehicle'),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                            builder: (_) => const VehicleCreateForm()),
                      );
                    },
                    icon: const Icon(Icons.directions_bike),
                    label: const Text('添加车辆'),
                  ),
                ],
              )
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        key: const Key('edit_vehicle'),
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('编辑'),
                      ),
                      TextButton.icon(
                        key: const Key('delete_vehicle'),
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete_outline, size: 18),
                        label: const Text('删除'),
                      ),
                    ],
                  ),
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
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _BatteryCard({
    required this.battery,
    required this.active,
    required this.typeLabel,
    required this.specLabel,
    required this.capacityKwh,
    required this.onEdit,
    required this.onDelete,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  key: Key('edit_battery_${battery.id}'),
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('编辑'),
                ),
                TextButton.icon(
                  key: Key('delete_battery_${battery.id}'),
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('删除'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String _fmtDate(DateTime d) => '${d.year}-${_two(d.month)}-${_two(d.day)}';
String _two(int n) => n < 10 ? '0$n' : '$n';

class _BatteryEditResult {
  final String name;
  final double? theoreticalRangeKm;
  final double? overrideCapacityKwh;
  const _BatteryEditResult(this.name, this.theoreticalRangeKm,
      this.overrideCapacityKwh);
}

class _BatteryEditDialog extends StatefulWidget {
  final Battery battery;
  const _BatteryEditDialog({required this.battery});

  @override
  State<_BatteryEditDialog> createState() => _BatteryEditDialogState();
}

class _BatteryEditDialogState extends State<_BatteryEditDialog> {
  late final TextEditingController _name =
      TextEditingController(text: widget.battery.name);
  late final TextEditingController _range = TextEditingController(
      text: widget.battery.theoreticalRangeKm?.toString() ?? '');
  late final TextEditingController _override = TextEditingController(
      text: widget.battery.overrideCapacityKwh?.toString() ?? '');

  @override
  void dispose() {
    _name.dispose();
    _range.dispose();
    _override.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('编辑电池'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            key: const Key('battery_name'),
            controller: _name,
            decoration: const InputDecoration(labelText: '名称'),
          ),
          TextField(
            key: const Key('battery_range'),
            controller: _range,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: '官方续航 km（可选）'),
          ),
          TextField(
            key: const Key('battery_override'),
            controller: _override,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: '容量覆盖 kWh（可选）'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        FilledButton(
          key: const Key('battery_save'),
          onPressed: () {
            final name = _name.text.trim();
            if (name.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('名称不能为空')),
              );
              return;
            }
            Navigator.of(context).pop(_BatteryEditResult(
              name,
              double.tryParse(_range.text),
              double.tryParse(_override.text),
            ));
          },
          child: const Text('保存'),
        ),
      ],
    );
  }
}
