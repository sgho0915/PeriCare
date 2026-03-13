import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pericare/features/session/providers/session_drain_provider.dart';
import 'package:pericare/features/session/screens/session_drain_screen.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  testWidgets('SessionDrainScreen shows progress and enables button on completion', (WidgetTester tester) async {
    final streamController = StreamController<List<WeightDataPoint>>();
    
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionDrainProvider.overrideWith((ref) => streamController.stream),
          targetDrainVolumeProvider.overrideWithValue(2000.0),
        ],
        child: const MaterialApp(
          home: SessionDrainScreen(),
        ),
      ),
    );

    // 1. Initial State: Loading
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    
    // 2. Data arrives
    final points = [
      WeightDataPoint(DateTime.now().subtract(const Duration(minutes: 1)), 500),
      WeightDataPoint(DateTime.now(), 1000),
    ];
    streamController.add(points);
    await tester.pumpAndSettle();

    expect(find.text('1000 / 2000 ml'), findsOneWidget);
    expect(find.byType(LineChart), findsOneWidget);
    
    // 3. 'Next' button is initially disabled
    ElevatedButton nextButton = tester.widget(find.widgetWithText(ElevatedButton, '다음 (세척 및 주입)'));
    expect(nextButton.onPressed, isNull);

    // 4. Manually mark as complete
    await tester.tap(find.text('배액 완료 (수동)'));
    await tester.pump();

    // 5. 'Next' button is now enabled
    nextButton = tester.widget(find.widgetWithText(ElevatedButton, '다음 (세척 및 주입)'));
    expect(nextButton.onPressed, isNotNull);

    streamController.close();
  });
}
