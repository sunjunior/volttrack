import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/charge.dart';
import '../../data/providers.dart';
import '../../shared/widgets/empty_state.dart';
import 'charging_form.dart';

class ChargingScreen extends ConsumerWidget {
  const ChargingScreen({super.key});

  static String modeLabel(ChargeMode m) => switch (m) {
        ChargeMode.byKwh => '按度数',
        ChargeMode.byTime => '按时长',
        ChargeMode.homeOutlet => '插座',
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chargesAsync = ref.watch(chargesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('记账')),
      body: chargesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败: $e')),
        data: (charges) {
          if (charges.isEmpty) {
            return EmptyState(
              icon: Icons.electric_bolt,
              message: '还没有充电记录',
              hint: '点击下方按钮记下第一笔充电',
              actionLabel: '去记一笔',
              onAction: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ChargingForm()),
                );
              },
            );
          }
          return ListView(
            padding: const EdgeInsets.all(8),
            children: [
              for (final c in charges)
                _ChargeTile(
                  charge: c,
                  onDelete: () => _confirmDelete(context, ref, c),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, ChargeRecord c) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除这条充电记录？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            key: const Key('confirm_delete'),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('删除'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(repoProvider).deleteCharge(c.id);
    }
  }
}

class _ChargeTile extends StatelessWidget {
  final ChargeRecord charge;
  final VoidCallback onDelete;

  const _ChargeTile({required this.charge, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final c = charge;
    return ListTile(
      title: Text(_fmtDateTime(c.occurredAt)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(ChargingScreen.modeLabel(c.mode)),
          Text('${c.energyKwh.toStringAsFixed(2)} kWh'),
          if (c.moneyYuan != null) Text('${c.moneyYuan!.toStringAsFixed(2)} 元'),
          if (c.mileageKm != null) Text('${c.mileageKm!.toStringAsFixed(1)} km'),
        ],
      ),
      trailing: IconButton(
        key: Key('delete_${c.id}'),
        icon: const Icon(Icons.delete_outline),
        onPressed: onDelete,
      ),
    );
  }
}

String _fmtDateTime(DateTime d) =>
    '${d.year}-${_two(d.month)}-${_two(d.day)} ${_two(d.hour)}:${_two(d.minute)}';
String _two(int n) => n < 10 ? '0$n' : '$n';
