import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers.dart';
import '../../core/engine/analytics.dart';
import '../../shared/widgets/empty_state.dart';

class HomeScreen extends ConsumerWidget {
  final VoidCallback? onGoToCharging;
  const HomeScreen({super.key, this.onGoToCharging});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(analyticsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('VoltTrack')),
      body: analytics.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败: $e')),
        data: (a) => a.windowCount == 0
            ? EmptyState(
                icon: Icons.electric_bolt,
                message: '还没有记账',
                hint: '点击下方按钮记下第一笔充电',
                actionLabel: '去记账',
                onAction: onGoToCharging ?? () {},
              )
            : _Overview(
                analytics: a,
                onGoToCharging: onGoToCharging ?? () {},
              ),
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  final Analytics analytics;
  final VoidCallback onGoToCharging;

  const _Overview({required this.analytics, required this.onGoToCharging});

  String _fmt(double? v) => v == null ? '--' : v.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _OverviewCard(
          title: '最近百公里电耗',
          value: _fmt(analytics.avgKwhPer100km),
          unit: 'kWh/100km',
          color: Colors.blue,
        ),
        _OverviewCard(
          title: '每公里成本',
          value: _fmt(analytics.avgYuanPerKm),
          unit: '元/km',
          color: Colors.orange,
        ),
        _OverviewCard(
          title: '预估续航',
          value: _fmt(analytics.predictedRangeKm),
          unit: 'km',
          color: Colors.green,
        ),
        _OverviewCard(
          title: '累计花费',
          value: analytics.totalCostYuan.toStringAsFixed(2),
          unit: '元',
          color: Colors.purple,
        ),
      ],
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final Color color;

  const _OverviewCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        value,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 4),
                      Text(unit, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
