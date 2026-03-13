import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pericare/features/main/providers/home_provider.dart';
import 'package:pericare/features/main/screens/home_screen.dart';

void main() {
  testWidgets('HomeScreen shows loading state and then data', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          patientNameProvider.overrideWith((ref) => Future.value('TestUser')),
          deviceStatusProvider.overrideWith((ref) => Stream.value({'status': 'Online', 'battery': 85})),
          todaySummaryProvider.overrideWith((ref) => {'completed_sessions': 1, 'total_uf': 150.0}),
        ],
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    // Initially, shows loading for patient name
    expect(find.text('로딩중...'), findsOneWidget);

    // Pump the widget again to settle the future provider
    await tester.pump();

    // After loading, shows patient name
    expect(find.text('안녕하세요, TestUser님'), findsOneWidget);
    
    // Pump the widget again to settle the stream provider
    await tester.pump();

    // Check for device status and summary
    expect(find.text('Online'), findsOneWidget);
    expect(find.text('85%'), findsOneWidget);
    expect(find.text('완료 횟수: 1회'), findsOneWidget);
    expect(find.text('총 제수량: 150.0 ml'), findsOneWidget);

    // Check for the main action button
    expect(find.text('투석 시작'), findsOneWidget);
  });
}
