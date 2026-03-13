import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pericare/features/session/providers/session_result_provider.dart';

class SessionResultScreen extends ConsumerWidget {
  const SessionResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Trigger the save operation when the screen is built.
    // The result is watched to show loading/error states.
    final saveState = ref.watch(sessionSaveProvider);

    final netUf = ref.watch(finalNetUfProvider);
    final targetUf = ref.watch(targetUfProvider);
    final achievementRate = targetUf > 0 ? (netUf / targetUf * 100).clamp(0, 1000) : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('투석 완료!'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '최종 제수량',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, color: Colors.grey),
            ),
            Text(
              '${netUf.toStringAsFixed(0)} ml',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            Text(
              '목표 제수량: ${targetUf.toStringAsFixed(0)} ml',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              '달성률: ${achievementRate.toStringAsFixed(1)}%',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            saveState.when(
              data: (_) => const Center(child: Text('세션 데이터가 저장되었습니다.')),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('저장 실패: $err')),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15)),
              onPressed: () => context.go('/history'), // Corrected to /history as /report may need a session id
              child: const Text('기록 보기', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => context.go('/home'),
              child: const Text('홈으로 돌아가기', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
