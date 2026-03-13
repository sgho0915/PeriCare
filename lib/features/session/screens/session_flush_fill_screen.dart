import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pericare/features/session/providers/session_flush_fill_provider.dart';

class SessionFlushFillScreen extends ConsumerStatefulWidget {
  const SessionFlushFillScreen({super.key});

  @override
  ConsumerState<SessionFlushFillScreen> createState() => _SessionFlushFillScreenState();
}

class _SessionFlushFillScreenState extends ConsumerState<SessionFlushFillScreen> {
  bool _isFlushing = true;
  int _flushCountdown = 5;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startFlushTimer();
  }

  void _startFlushTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_flushCountdown == 1) {
        timer.cancel();
        setState(() {
          _isFlushing = false;
        });
      } else {
        setState(() {
          _flushCountdown--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isFlushing ? '3. 세척 (Flush)' : '4. 주입 (Fill)'),
      ),
      body: _isFlushing ? _buildFlushView() : _buildFillView(),
    );
  }

  Widget _buildFlushView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('세척 과정', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 20),
          Text(
            '$_flushCountdown',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text('초 후 주입 단계로 넘어갑니다.'),
        ],
      ),
    );
  }

  Widget _buildFillView() {
    final drainWeight = ref.watch(finalDrainWeightProvider);
    final injectedVolume = ref.watch(injectedVolumeProvider);
    final netUf = drainWeight - injectedVolume;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildInfoCard('배액량 (Out)', '${drainWeight.toStringAsFixed(0)} ml', Colors.orange.shade100),
          _buildInfoCard('주입량 (In)', '${injectedVolume.toStringAsFixed(0)} ml', Colors.blue.shade100),
          _buildInfoCard('현재 제수량 (Net UF)', '${netUf.toStringAsFixed(0)} ml', Colors.green.shade100, isLarge: true),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20),
            ),
            onPressed: () {
              // TODO: Save final data to Firestore
              context.go('/session/result');
            },
            child: const Text('완료', style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, Color color, {bool isLarge = false}) {
    return Card(
      color: color,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(title, style: TextStyle(fontSize: isLarge ? 20 : 16, color: Colors.black87)),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: isLarge ? 48 : 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
