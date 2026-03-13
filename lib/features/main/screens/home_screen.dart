import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pericare/features/main/providers/home_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientName = ref.watch(patientNameProvider);
    final deviceStatus = ref.watch(deviceStatusProvider);
    final todaySummary = ref.watch(todaySummaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: patientName.when(
          data: (name) => Text('안녕하세요, $name님'),
          loading: () => const Text('로딩중...'),
          error: (err, stack) => const Text('오류'),
        ),
        actions: [
          deviceStatus.when(
            data: (status) => Row(
              children: [
                Text(status['status']),
                const SizedBox(width: 8),
                Icon(
                  status['status'] == 'Online' ? Icons.wifi : Icons.wifi_off,
                  color: status['status'] == 'Online' ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                // TODO: Change icon based on battery level
                Text('${status['battery']}%'),
                const Icon(Icons.battery_full), 
                const SizedBox(width: 16),
              ],
            ),
            loading: () => const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
            ),
            error: (err, stack) => const Icon(Icons.error),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const SizedBox.shrink(),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('오늘의 투석 요약', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 24),
                      Text('완료 횟수: ${todaySummary['completed_sessions']}회', style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Text('총 제수량: ${todaySummary['total_uf']} ml', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () {
                  context.go('/session/prep');
                },
                child: const Text('투석 시작', style: TextStyle(fontSize: 24)),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 1:
              context.go('/history');
              break;
            case 2:
              context.go('/settings');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: '기록',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
      ),
    );
  }
}
