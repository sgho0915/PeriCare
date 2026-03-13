import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pericare/core/firebase/firebase_providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // initState에서 비동기 작업을 수행하고 화면 전환을 위해 runAfterFirstLayout을 사용합니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthAndNavigate();
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    // 잠시 대기하여 스플래시 화면을 보여주고 앱 초기화 시간을 확보합니다.
    await Future.delayed(const Duration(seconds: 2));

    final firebaseAuth = ref.read(firebaseAuthProvider);
    
    // 위젯이 마운트된 상태인지 확인 후 화면 전환
    if (mounted) {
      if (firebaseAuth.currentUser != null) {
        // 사용자가 로그인 되어 있으면 홈으로 이동
        context.go('/home');
      } else {
        // 로그인 되어 있지 않으면 로그인 화면으로 이동
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('앱을 준비하는 중입니다...'),
          ],
        ),
      ),
    );
  }
}
