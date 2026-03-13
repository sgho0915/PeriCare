import 'package:go_router/go_router.dart';
import 'package:pericare/features/auth/screens/login_screen.dart';
import 'package:pericare/features/auth/screens/device_register_screen.dart';
import 'package:pericare/features/main/screens/home_screen.dart';
import 'package:pericare/features/main/screens/splash_screen.dart';
import 'package:pericare/features/session/screens/session_prep_screen.dart';
import 'package:pericare/features/session/screens/session_drain_screen.dart';
import 'package:pericare/features/session/screens/session_flush_fill_screen.dart';
import 'package:pericare/features/session/screens/session_result_screen.dart';
import 'package:pericare/features/session/screens/manual_input_screen.dart';
import 'package:pericare/features/history/screens/history_screen.dart';
import 'package:pericare/features/history/screens/report_screen.dart';
import 'package:pericare/features/settings/screens/settings_screen.dart';

// TODO: Implement ShellRoute for session screens as mentioned in GEMINI.md

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const DeviceRegisterScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/session/prep',
      builder: (context, state) => const SessionPrepScreen(),
    ),
    GoRoute(
      path: '/session/drain',
      builder: (context, state) => const SessionDrainScreen(),
    ),
    GoRoute(
      path: '/session/flush_fill',
      builder: (context, state) => const SessionFlushFillScreen(),
    ),
    GoRoute(
      path: '/session/result',
      builder: (context, state) => const SessionResultScreen(),
    ),
    GoRoute(
      path: '/session/manual',
      builder: (context, state) => const ManualInputScreen(),
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const HistoryScreen(),
    ),
    GoRoute(
      path: '/report',
      builder: (context, state) => const ReportScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
