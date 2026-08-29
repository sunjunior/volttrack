import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/engine/energy_derivation.dart';
import '../../core/models/charge.dart';
import '../../data/providers.dart';

class ChargingForm extends ConsumerStatefulWidget {
  const ChargingForm({super.key});
  @override
  ConsumerState<ChargingForm> createState() => _ChargingFormState();
}

class _ChargingFormState extends ConsumerState<ChargingForm> {
  ChargeMode _mode = ChargeMode.byKwh;
  final _kwh = TextEditingController();
  final _money = TextEditingController();
  final _unitPrice = TextEditingController();
  final _hours = TextEditingController();
  final _power = TextEditingController();
  final _socBefore = TextEditingController();
  final _socAfter = TextEditingController();
  final _mileage = TextEditingController();

  @override
  void dispose() {
    _kwh.dispose();
    _money.dispose();
    _unitPrice.dispose();
    _hours.dispose();
    _power.dispose();
    _socBefore.dispose();
    _socAfter.dispose();
    _mileage.dispose();
    super.dispose();
  }

  static double? _d(String s) => s.isEmpty ? null : double.tryParse(s);

  EnergyResult? _preview() {
    final battery = ref.read(activeBatteryProvider).value;
    final capacity = battery == null
        ? null
        : (battery.overrideCapacityKwh ?? battery.voltageV * battery.capacityAh / 1000);
    try {
      return deriveEnergyKwh(
        mode: _mode,
        enteredKwh: _d(_kwh.text),
        moneyYuan: _d(_money.text),
        unitPriceYuanPerKwh: _d(_unitPrice.text),
        hours: _d(_hours.text),
        powerW: _d(_power.text),
        socBeforePct: int.tryParse(_socBefore.text),
        socAfterPct: int.tryParse(_socAfter.text),
        capacityKwh: capacity,
      );
    } on ArgumentError {
      return null;
    }
  }

  bool get _byKwh => _mode == ChargeMode.byKwh;
  bool get _byTime => _mode == ChargeMode.byTime;
  bool get _homeOutlet => _mode == ChargeMode.homeOutlet;

  bool get _hasValidSource {
    switch (_mode) {
      case ChargeMode.byKwh:
        final kwh = _d(_kwh.text);
        if (kwh != null && kwh > 0) return true;
        final money = _d(_money.text);
        final unitPrice = _d(_unitPrice.text);
        return money != null && unitPrice != null && unitPrice > 0;
      case ChargeMode.byTime:
        final hours = _d(_hours.text);
        final power = _d(_power.text);
        return hours != null && hours > 0 && power != null && power > 0;
      case ChargeMode.homeOutlet:
        final before = int.tryParse(_socBefore.text);
        final after = int.tryParse(_socAfter.text);
        if (before != null && after != null && after > before) return true;
        final kwh = _d(_kwh.text);
        return kwh != null && kwh > 0;
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _save() async {
    final battery = ref.read(activeBatteryProvider).value;
    if (battery == null) {
      _showMessage('请先在档案页添加电池');
      return;
    }
    if (!_hasValidSource) {
      _showMessage('请完整填写当前模式的计费信息');
      return;
    }
    final result = _preview()!;
    final repo = ref.read(repoProvider);
    await repo.addCharge(c: ChargeRecord(
      batteryId: battery.id,
      occurredAt: DateTime.now(),
      mode: _mode,
      energyKwh: result.kwh,
      energySource: result.source,
      moneyYuan: _d(_money.text),
      hours: _d(_hours.text),
      chargerPowerW: _d(_power.text),
      socBeforePct: int.tryParse(_socBefore.text),
      socAfterPct: int.tryParse(_socAfter.text),
      mileageKm: _d(_mileage.text),
    ));
    if (mounted) {
      if (Navigator.canPop(context)) Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已记录')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final liters = _preview()?.kwh;
    final money = _d(_money.text);
    return Scaffold(
      appBar: AppBar(title: const Text('记账')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SegmentedButton<ChargeMode>(
            segments: const [
              ButtonSegment(value: ChargeMode.byKwh, label: Text('按度数')),
              ButtonSegment(value: ChargeMode.byTime, label: Text('按时长')),
              ButtonSegment(value: ChargeMode.homeOutlet, label: Text('插座')),
            ],
            selected: {_mode},
            onSelectionChanged: (s) => setState(() => _mode = s.first),
          ),
          const SizedBox(height: 16),
          if (_byKwh) ...[
            _field('充电度数', _kwh, const Key('kwh'), hint: 'kWh'),
            _field('金额', _money, const Key('money'), hint: '元'),
            _field('单价', _unitPrice, const Key('unit_price'), hint: '元/kWh'),
          ],
          if (_byTime) ...[
            _field('时长', _hours, const Key('hours'), hint: '小时'),
            _field('功率', _power, const Key('power_w'), hint: 'W'),
          ],
          if (_homeOutlet) ...[
            _field('起始电量', _socBefore, const Key('soc_before'), hint: '%'),
            _field('结束电量', _socAfter, const Key('soc_after'), hint: '%'),
            _field('充电度数(可选)', _kwh, const Key('kwh'), hint: 'kWh'),
          ],
          _field('里程', _mileage, const Key('mileage'), hint: 'km'),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('实时预览', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  if (liters != null)
                    Text(
                      '${liters.toStringAsFixed(2)} kWh',
                      key: const Key('preview_kwh'),
                      style: Theme.of(context).textTheme.headlineSmall,
                    )
                  else
                    const Text('输入不足，暂时无法推算度数'),
                  if (liters != null && money != null)
                    Text(
                      '费用 ${money.toStringAsFixed(2)} 元',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  if (_byTime && liters != null)
                    Text(
                      '按时长模式按计费档进一',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
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

  Widget _field(String label, TextEditingController ctrl, Key key,
      {String? hint}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        key: key,
        controller: ctrl,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }
}
