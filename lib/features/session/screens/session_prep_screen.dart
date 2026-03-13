import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pericare/features/session/providers/session_prep_provider.dart';

class SessionPrepScreen extends ConsumerWidget {
  const SessionPrepScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prepData = ref.watch(sessionPrepProvider);
    final isAutoTareDone = ref.watch(autoTareProvider);
    
    final isSafe = prepData.asData?.value['is_safe'] ?? true;

    final canProceed = isSafe && isAutoTareDone;

    return Scaffold(
      backgroundColor: isSafe ? Colors.white : Colors.red.shade100,
      appBar: AppBar(
        title: const Text('1. 환경 스캔 및 영점 조절'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!isSafe)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade700,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "창문을 닫고 밀폐 환경을 만드세요!",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            const Spacer(),
            Text(
              '현재 풍속',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            prepData.when(
              data: (data) => Text(
                '${data['wind_speed_ms']} m/s',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => const Text('데이터를 불러올 수 없습니다.'),
            ),
            const SizedBox(height: 40),
            OutlinedButton.icon(
              icon: Icon(isAutoTareDone ? Icons.check_circle : Icons.radio_button_unchecked),
              label: const Text('자동 영점 조절(Auto-Tare) 완료'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                foregroundColor: isAutoTareDone ? Colors.green : Colors.grey,
              ),
              onPressed: () {
                ref.read(autoTareProvider.notifier).state = true;
              },
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                backgroundColor: canProceed ? Colors.blue : Colors.grey,
              ),
              onPressed: canProceed
                  ? () => context.go('/session/drain')
                  : null,
              child: const Text('다음 (배액 시작)', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
