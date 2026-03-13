import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pericare/features/session/providers/session_flush_fill_provider.dart';
import 'package:pericare/features/session/screens/session_flush_fill_screen.dart';

void main() {
  // Override providers with mock values for testing
  final mockFinalDrainWeightProvider = finalDrainWeightProvider.overrideWithValue(2300.0);
  final mockPrescribedFillVolumeProvider = prescribedFillVolumeProvider.overrideWithValue(2000.0);
  // Simulate fill weight stream that ends at a specific value
  final mockFillWeightProvider = fillWeightProvider.overrideWith(
    (ref) => Stream.value(1000.0), // Current weight on scale is 1000ml
  );

  testWidgets('SessionFlushFillScreen transitions from Flush to Fill and shows correct data', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          mockFinalDrainWeightProvider,
          mockPrescribedFillVolumeProvider,
          mockFillWeightProvider,
        ],
        child: const MaterialApp(
          home: SessionFlushFillScreen(),
        ),
      ),
    );

    // 1. Initial State: Flush view with countdown from 5
    expect(find.text('3. 세척 (Flush)'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    
    // 2. Pump through the 5-second flush countdown
    await tester.pump(const Duration(seconds: 5));

    // 3. Settle all frames to ensure the stream has emitted and UI has rebuilt
    await tester.pumpAndSettle();
    
    // 4. Verify Fill view is now showing
    expect(find.text('4. 주입 (Fill)'), findsOneWidget);
    
    // Check the data cards
    // Drained = 2300 ml
    expect(find.text('2300 ml'), findsOneWidget);
    
    // Injected = Prescribed (2000) - Current (1000) = 1000 ml
    expect(find.text('1000 ml'), findsOneWidget); 
    
    // Net UF = Drained (2300) - Injected (1000) = 1300 ml
    expect(find.text('1300 ml'), findsOneWidget);
    
    // Verify the "Complete" button
    expect(find.text('완료'), findsOneWidget);
  });
}
