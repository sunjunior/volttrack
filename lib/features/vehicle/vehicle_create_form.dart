import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers.dart';
import '../../data/tables.dart';

class VehicleCreateForm extends ConsumerStatefulWidget {
  final Vehicle? existing;
  const VehicleCreateForm({super.key, this.existing});
  @override
  ConsumerState<VehicleCreateForm> createState() => _VehicleCreateFormState();
}

class _VehicleCreateFormState extends ConsumerState<VehicleCreateForm> {
  Vehicle? get _editing => widget.existing;
  late final TextEditingController _brand;
  late final TextEditingController _model;
  late final TextEditingController _mileage;
  DateTime? _purchaseDate;

  @override
  void initState() {
    super.initState();
    _brand = TextEditingController(text: widget.existing?.brand ?? '');
    _model = TextEditingController(text: widget.existing?.model ?? '');
    _mileage = TextEditingController(
        text: widget.existing == null
            ? ''
            : widget.existing!.initialMileageKm.toString());
    _purchaseDate = widget.existing?.purchaseDate;
  }

  @override
  void dispose() {
    _brand.dispose();
    _model.dispose();
    _mileage.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _save() async {
    final brand = _brand.text.trim();
    final model = _model.text.trim();
    if (brand.isEmpty || model.isEmpty) {
      _showMessage('请完整填写必填项');
      return;
    }
    final mileage = double.tryParse(_mileage.text);
    final db = ref.read(dbProvider);
    if (_editing != null) {
      await (db.update(db.vehicles)..where((t) => t.id.equals(_editing!.id)))
          .write(VehiclesCompanion(
        brand: Value(brand),
        model: Value(model),
        purchaseDate: Value(_purchaseDate),
        initialMileageKm: Value(mileage ?? _editing!.initialMileageKm),
      ));
    } else {
      await db.into(db.vehicles).insert(VehiclesCompanion.insert(
            brand: brand,
            model: model,
            purchaseDate: _purchaseDate == null
                ? const Value.absent()
                : Value(_purchaseDate!),
            initialMileageKm: Value(mileage ?? 0.0),
          ));
    }
    if (mounted && Navigator.canPop(context)) {
      Navigator.pop(context, true);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _purchaseDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _purchaseDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_editing == null ? '添加车辆' : '编辑车辆')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            key: const Key('brand'),
            controller: _brand,
            decoration: const InputDecoration(
              labelText: '品牌',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            key: const Key('model'),
            controller: _model,
            decoration: const InputDecoration(
              labelText: '型号',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('购入时间（可选）'),
            subtitle: Text(_purchaseDate == null
                ? '未填写'
                : '${_purchaseDate!.year}-${_purchaseDate!.month}-${_purchaseDate!.day}'),
            trailing: const Icon(Icons.calendar_today),
            onTap: _pickDate,
          ),
          TextField(
            key: const Key('initial_mileage'),
            controller: _mileage,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: '初始里程 km（可选）',
              border: OutlineInputBorder(),
            ),
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
}
