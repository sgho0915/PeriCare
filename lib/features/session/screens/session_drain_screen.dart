import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pericare/features/session/providers/session_drain_provider.dart';

class SessionDrainScreen extends ConsumerWidget {
  const SessionDrainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drainData = ref.watch(sessionDrainProvider);
    final targetVolume = ref.watch(targetDrainVolumeProvider);
    // TODO: Implement automatic completion logic
    final isComplete = ref.watch(isDrainCompleteProvider);

    final currentWeight = drainData.asData?.value.lastOrNull?.weight ?? 0.0;
    final progress = (currentWeight / targetVolume).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('2. 배액'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: progress,
              minHeight: 10,
            ),
            const SizedBox(height: 10),
            Text(
              '${currentWeight.toStringAsFixed(0)} / ${targetVolume.toStringAsFixed(0)} ml',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: drainData.when(
                data: (points) => LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: points
                            .map((p) => FlSpot(p.timestamp.millisecondsSinceEpoch.toDouble(), p.weight))
                            .toList(),
                        isCurved: true,
                        barWidth: 4,
                        color: Colors.blue,
                        belowBarData: BarAreaData(show: true, color: Colors.blue.withAlpha((255 * 0.3).round())),
                      ),
                    ],
                    titlesData: const FlTitlesData(
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: const FlGridData(show: true),
                    borderData: FlBorderData(show: true),
                  ),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ),
            const SizedBox(height: 20),
            // Manual completion for now
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () => ref.read(isDrainCompleteProvider.notifier).state = true,
              child: const Text('배액 완료 (수동)'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: isComplete ? Colors.blue : Colors.grey,
              ),
              onPressed: isComplete ? () => context.go('/session/flush_fill') : null,
              child: const Text('다음 (세척 및 주입)', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
