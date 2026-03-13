import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pericare/features/session/providers/session_result_provider.dart';
import 'package:pericare/features/session/screens/session_result_screen.dart';

void main() {
  // 1. Mock the providers with specific values for the test
  final mockNetUfProvider = finalNetUfProvider.overrideWithValue(225.0);
  final mockTargetUfProvider = targetUfProvider.overrideWithValue(250.0);
  
  // Mock the save provider to simulate a network call
  final mockSessionSaveProvider = sessionSaveProvider.overrideWith((ref) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return; // Simulate success
  });

  testWidgets('SessionResultScreen shows final results and save status', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          mockNetUfProvider,
          mockTargetUfProvider,
          mockSessionSaveProvider,
        ],
        child: const MaterialApp(
          home: SessionResultScreen(),
        ),
      ),
    );

    // 2. Initially, the save provider is in a loading state
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // 3. Verify the displayed numbers before save completes
    // Final Net UF = 225.0
    expect(find.text('225 ml'), findsOneWidget); 
    // Target UF = 250.0
    expect(find.text('목표 제수량: 250 ml'), findsOneWidget);
    // Achievement = 225 / 250 * 100 = 90.0%
    expect(find.text('달성률: 90.0%'), findsOneWidget);

    // 4. Pump the widget to allow the FutureProvider to complete
    await tester.pumpAndSettle();

    // 5. Now, the loading indicator should be gone, and a success message should appear
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('세션 데이터가 저장되었습니다.'), findsOneWidget);

    // 6. Verify the navigation buttons exist
    expect(find.text('기록 보기'), findsOneWidget);
    expect(find.text('홈으로 돌아가기'), findsOneWidget);
  });
}
