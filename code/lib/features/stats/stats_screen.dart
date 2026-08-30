import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/engine/analytics.dart';
import '../../core/engine/energy_window.dart';
import '../../core/engine/soh.dart';
import '../../data/battery_x.dart';
import '../../data/providers.dart';
import '../../data/tables.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(analyticsProvider);
    final battery = ref.watch(activeBatteryProvider).value;
    return Scaffold(
      appBar: AppBar(title: const Text('统计')),
      body: analytics.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败: $e')),
        data: (a) => _StatsView(analytics: a, battery: battery),
      ),
    );
  }
}

class _StatsView extends StatelessWidget {
  final Analytics analytics;
  final Battery? battery;

  const _StatsView({required this.analytics, this.battery});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _BatterySelector(battery: battery),
        _LineChart(analytics.windows),
        _SohCard(analytics: analytics, battery: battery),
        _RangeCard(analytics: analytics, battery: battery),
      ],
    );
  }
}

class _BatterySelector extends StatelessWidget {
  final Battery? battery;

  const _BatterySelector({this.battery});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text('当前生效电池', style: Theme.of(context).textTheme.bodyMedium),
          const Spacer(),
          DropdownButton<String>(
            hint: Text(battery?.name ?? '未添加'),
            items: const [],
            onChanged: null,
          ),
        ],
      ),
    );
  }
}

class _LineChart extends StatelessWidget {
  final List<ConsumptionWindow> windows;

  const _LineChart(this.windows);

  @override
  Widget build(BuildContext context) {
    final sorted = [...windows]
      ..sort((a, b) => a.start.occurredAt.compareTo(b.start.occurredAt));
    final spots = <FlSpot>[];
    final unusuals = <bool>[];
    for (final w in sorted) {
      final x = w.end.mileageKm;
      if (x == null) continue;
      spots.add(FlSpot(x, w.kwhPer100km));
      unusuals.add(w.unusual);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('电耗趋势', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              width: double.infinity,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 2,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, xPercent, bar, index) {
                          final unusual =
                              index < unusuals.length && unusuals[index];
                          return FlDotCirclePainter(
                            radius: unusual ? 5 : 4,
                            color: unusual ? Colors.red : Colors.blue,
                            strokeWidth: 0,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SohCard extends StatelessWidget {
  final Analytics analytics;
  final Battery? battery;

  const _SohCard({required this.analytics, this.battery});

  String? _sohPct() {
    final battery = this.battery;
    if (battery == null) return null;
    final capacityKwh = battery.capacityKwh;
    for (final w in analytics.windows.reversed) {
      final start = w.start;
      if ((start.socAfterPct ?? 0) >= 95 && (start.socBeforePct ?? 100) <= 10) {
        final soh = sohEstimate(
          energyKwh: start.energyKwh,
          capacityKwh: capacityKwh,
          socBeforePct: start.socBeforePct ?? 0,
          socAfterPct: start.socAfterPct ?? 100,
        );
        if (soh != null) return '${(soh * 100).toStringAsFixed(1)}%';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return _StatCard(
      title: '电池健康度 (SOH)',
      value: _sohPct() ?? '数据积累中',
      note: '依最近满电窗口估算',
    );
  }
}

class _RangeCard extends StatelessWidget {
  final Analytics analytics;
  final Battery? battery;

  const _RangeCard({required this.analytics, this.battery});

  @override
  Widget build(BuildContext context) {
    final theoretical = battery?.theoreticalRangeKm;
    final ratio = rangeAchievement(
      fullRideWindows: fullRideWindows(analytics.windows),
      theoreticalRangeKm: theoretical,
    );

    String value;
    String note;
    if (theoretical == null) {
      value = '--';
      note = '档案中填写官方续航后可计算达成率';
    } else if (ratio == null) {
      value = '--';
      note = '数据积累中';
    } else {
      value = '${(ratio * 100).toStringAsFixed(1)}%';
      note = '平均实际续航 ÷ 官方续航';
    }

    return _StatCard(
      title: '续航达成率',
      value: value,
      note: note,
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String note;

  const _StatCard({
    required this.title,
    required this.value,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(note, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
