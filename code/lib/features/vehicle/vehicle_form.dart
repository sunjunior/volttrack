import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/battery.dart' show BatteryType;
import '../../data/providers.dart';
import '../../data/tables.dart';

class VehicleForm extends ConsumerStatefulWidget {
  const VehicleForm({super.key});
  @override
  ConsumerState<VehicleForm> createState() => _VehicleFormState();
}

class _VehicleFormState extends ConsumerState<VehicleForm> {
  final _name = TextEditingController();
  final _voltage = TextEditingController();
  final _capacity = TextEditingController();
  final _range = TextEditingController();
  BatteryType _type = BatteryType.ternaryLithium;
  DateTime _installedAt = DateTime.now();

  @override
  void dispose() {
    _name.dispose();
    _voltage.dispose();
    _capacity.dispose();
    _range.dispose();
    super.dispose();
  }

  static double? _d(String s) => s.isEmpty ? null : double.tryParse(s);

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    final voltage = _d(_voltage.text);
    final capacity = _d(_capacity.text);
    final range = _d(_range.text);
    if (name.isEmpty ||
        voltage == null ||
        voltage <= 0 ||
        capacity == null ||
        capacity <= 0) {
      _showMessage('请完整填写必填项');
      return;
    }
    if (range != null && range <= 0) {
      _showMessage('官方续航需大于 0');
      return;
    }
    final db = ref.read(dbProvider);
    final vehicles = await db.select(db.vehicles).get();
    if (vehicles.isEmpty) {
      _showMessage('请先添加车辆');
      return;
    }
    final vehicleId = vehicles.first.id;
    final active = ref.read(activeBatteryProvider).value;
    if (active != null) {
      await (db.update(db.batteries)
            ..where((b) => b.id.equals(active.id)))
          .write(BatteriesCompanion(
            active: const Value(false),
            deactivatedAt: Value(DateTime.now()),
          ));
    }
    await db.into(db.batteries).insert(BatteriesCompanion.insert(
          vehicleId: vehicleId,
          name: name,
          type: _type,
          voltageV: voltage,
          capacityAh: capacity,
          theoreticalRangeKm: range == null ? const Value.absent() : Value(range),
          installedAt: _installedAt,
        ));
    if (mounted && Navigator.canPop(context)) {
      Navigator.pop(context, true);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _installedAt,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _installedAt = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('更换电池')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            key: const Key('name'),
            controller: _name,
            decoration: const InputDecoration(
              labelText: '名称',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<BatteryType>(
            key: const Key('type'),
            initialValue: _type,
            items: const [
              DropdownMenuItem(
                  value: BatteryType.leadAcid, child: Text('铅酸')),
              DropdownMenuItem(
                  value: BatteryType.lifepo4, child: Text('磷酸铁锂')),
              DropdownMenuItem(
                  value: BatteryType.ternaryLithium, child: Text('三元锂')),
            ],
            onChanged: (v) => setState(() => _type = v ?? _type),
            decoration: const InputDecoration(
              labelText: '类型',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          _numField('电压 (V)', _voltage, const Key('voltage')),
          _numField('容量 (Ah)', _capacity, const Key('capacity')),
          _numField('官方续航 km（可选）', _range, const Key('range')),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('安装日期'),
            subtitle: Text(_fmtDate(_installedAt)),
            trailing: const Icon(Icons.calendar_today),
            onTap: _pickDate,
          ),
          const SizedBox(height: 16),
          FilledButton(
            key: const Key('save'),
            onPressed: _save,
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  Widget _numField(String label, TextEditingController ctrl, Key key) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        key: key,
        controller: ctrl,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

String _fmtDate(DateTime d) => '${d.year}-${_two(d.month)}-${_two(d.day)}';
String _two(int n) => n < 10 ? '0$n' : '$n';