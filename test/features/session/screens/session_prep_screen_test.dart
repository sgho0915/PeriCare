import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pericare/features/session/providers/session_prep_provider.dart';
import 'package:pericare/features/session/screens/session_prep_screen.dart';

void main() {
  testWidgets('SessionPrepScreen enables button when safe and tare is done', (WidgetTester tester) async {
    final streamController = StreamController<Map<String, dynamic>>();
    
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionPrepProvider.overrideWith((ref) => streamController.stream),
        ],
        child: const MaterialApp(
          home: SessionPrepScreen(),
        ),
      ),
    );

    // 1. Initial State: Safe, but Auto-Tare not done. Button should be disabled.
    streamController.add({'is_safe': true, 'wind_speed_ms': 0.1});
    await tester.pumpAndSettle();

    expect(find.text('다음 (배액 시작)'), findsOneWidget);
    ElevatedButton nextButton = tester.widget(find.byType(ElevatedButton));
    expect(nextButton.onPressed, isNull);
    expect(find.text("창문을 닫고 밀폐 환경을 만드세요!"), findsNothing);

    // 2. Unsafe State: Not safe, Auto-Tare not done. Button disabled, warning visible.
    streamController.add({'is_safe': false, 'wind_speed_ms': 2.5});
    await tester.pumpAndSettle();

    nextButton = tester.widget(find.byType(ElevatedButton));
    expect(nextButton.onPressed, isNull);
    expect(find.text("창문을 닫고 밀폐 환경을 만드세요!"), findsOneWidget);

    // 3. Safe again, but Auto-Tare still not done. Button should be disabled.
    streamController.add({'is_safe': true, 'wind_speed_ms': 0.2});
    await tester.pumpAndSettle();
    
    nextButton = tester.widget(find.byType(ElevatedButton));
    expect(nextButton.onPressed, isNull);
    expect(find.text("창문을 닫고 밀폐 환경을 만드세요!"), findsNothing);

    // 4. User confirms Auto-Tare. Now the button should be enabled.
    await tester.tap(find.text('자동 영점 조절(Auto-Tare) 완료'));
    await tester.pumpAndSettle();

    nextButton = tester.widget(find.byType(ElevatedButton));
    expect(nextButton.onPressed, isNotNull);

    // Close the stream controller
    streamController.close();
  });
}
