import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/engine/charge_calculator.dart';
import '../../data/battery_x.dart';
import '../../data/providers.dart';

class CalculatorScreen extends ConsumerWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final battery = ref.watch(activeBatteryProvider).value;
    final capacityKwh = battery?.capacityKwh;
    return _CalculatorBody(capacityKwh: capacityKwh);
  }
}

class _CalculatorBody extends StatefulWidget {
  final double? capacityKwh;

  const _CalculatorBody({this.capacityKwh});

  @override
  State<_CalculatorBody> createState() => _CalculatorBodyState();
}

class _CalculatorBodyState extends State<_CalculatorBody> {
  final _energy = TextEditingController();
  final _capacity = TextEditingController();
  final _aPower = TextEditingController(text: '300');
  final _aSliceHours = TextEditingController(text: '3');
  final _aPrice = TextEditingController(text: '2');
  final _bPrice = TextEditingController();
  final _monthly = TextEditingController(text: '22');

  @override
  void initState() {
    super.initState();
    _applyCapacity(widget.capacityKwh);
  }

  @override
  void didUpdateWidget(_CalculatorBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.capacityKwh != oldWidget.capacityKwh && _capacity.text.isEmpty) {
      _applyCapacity(widget.capacityKwh);
    }
  }

  void _applyCapacity(double? capacityKwh) {
    if (capacityKwh == null) return;
    _capacity.text = capacityKwh
        .toStringAsFixed(2)
        .replaceFirst(RegExp(r'\.?0+$'), '');
  }

  @override
  void dispose() {
    _energy.dispose();
    _capacity.dispose();
    _aPower.dispose();
    _aSliceHours.dispose();
    _aPrice.dispose();
    _bPrice.dispose();
    _monthly.dispose();
    super.dispose();
  }

  static double? _d(String s) => s.isEmpty ? null : double.tryParse(s);
  static int? _i(String s) => s.isEmpty ? null : int.tryParse(s);

  List<ChargingOption>? _options(double energy) {
    final power = _d(_aPower.text);
    final sliceHours = _d(_aSliceHours.text);
    final price = _d(_aPrice.text);
    final bPrice = _d(_bPrice.text);
    if (energy <= 0 ||
        power == null || power <= 0 ||
        sliceHours == null || sliceHours <= 0 ||
        price == null || price <= 0 ||
        bPrice == null || bPrice <= 0) {
      return null;
    }
    return [
      ChargingOption('方案A', (e) => costByTimeSlices(
            energyKwh: e,
            powerW: power,
            yuanPerSlice: price,
            sliceHours: sliceHours,
          )),
      ChargingOption('方案B', (e) => costByKwh(energyKwh: e, yuanPerKwh: bPrice)),
    ];
  }

  Widget _field(String label, TextEditingController ctrl, Key key) {
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
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  Widget _cheaperBadge(Key key) {
    return Container(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text('更省', style: TextStyle(color: Colors.white, fontSize: 12)),
    );
  }

  Widget _schemeCard({
    required String title,
    required List<Widget> fields,
    required String? cost,
    required Key costKey,
    required bool isCheaper,
    required Key cheapKey,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(title,
                      style: Theme.of(context).textTheme.titleMedium),
                ),
                if (isCheaper) _cheaperBadge(cheapKey),
              ],
            ),
            const SizedBox(height: 4),
            ...fields,
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  cost ?? '--',
                  key: costKey,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 4),
                Text('元/次', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final energy = _d(_energy.text);
    final options = energy != null && energy > 0 ? _options(energy) : null;
    List<double>? costs;
    var cheapest = -1;
    if (options != null && energy != null) {
      costs = [for (final o in options) o.costOf(energy)];
      cheapest = cheapestOption(options, energy);
    }
    final sliceLabel = _aSliceHours.text.isEmpty
        ? 'N'
        : _aSliceHours.text;
    final months = _i(_monthly.text);
    final diff = costs == null
        ? null
        : (costs[0] > costs[1] ? costs[0] - costs[1] : costs[1] - costs[0]);

    return Scaffold(
      appBar: AppBar(title: const Text('充电费用计算')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _field('充入度数 (kWh)', _energy, const Key('energy')),
          _field('电池容量 (kWh，可留空)', _capacity, const Key('capacity')),
          const SizedBox(height: 16),
          _schemeCard(
            title: '方案 A · 按时长档位',
            fields: [
              _field('功率 (W)', _aPower, const Key('a_power')),
              _field('每档时长 (小时)', _aSliceHours, const Key('a_slice_hours')),
              _field('单价（元 / $sliceLabel小时）', _aPrice, const Key('a_price')),
            ],
            cost: costs == null ? null : costs[0].toStringAsFixed(2),
            costKey: const Key('cost_a'),
            isCheaper: cheapest == 0,
            cheapKey: const Key('cheap_a'),
          ),
          const SizedBox(height: 12),
          _schemeCard(
            title: '方案 B · 按度',
            fields: [_field('单价 (元/kWh)', _bPrice, const Key('b_price'))],
            cost: costs == null ? null : costs[1].toStringAsFixed(2),
            costKey: const Key('cost_b'),
            isCheaper: cheapest == 1,
            cheapKey: const Key('cheap_b'),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('实时对比',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  if (costs == null)
                    const Text('输入充入度数与两边方案信息后开始对比')
                  else ...[
                    Text('方案 A ${costs[0].toStringAsFixed(2)} 元/次',
                        key: const Key('summary_a')),
                    Text('方案 B ${costs[1].toStringAsFixed(2)} 元/次',
                        key: const Key('summary_b')),
                    const SizedBox(height: 8),
                    Text('每次差额 '
                        '${diff!.toStringAsFixed(2)} 元'),
                    const SizedBox(height: 8),
                    _field('每月充电次数', _monthly, const Key('monthly')),
                    if (months != null && months > 0)
                      Text('月度差额 '
                          '${(diff * months).toStringAsFixed(2)} 元')
                    else
                      const Text('月度差额 -- 元'),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}