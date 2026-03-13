import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pericare/core/firebase/firebase_providers.dart';

// TODO: The session ID should be dynamically set when a session starts.
const String _sessionId = "session_123"; 

final sessionPrepProvider = StreamProvider<Map<String, dynamic>>((ref) {
  final db = ref.watch(realtimeDbProvider);
  final controller = StreamController<Map<String, dynamic>>();

  // Default state before first data arrives
  controller.add({
    'wind_speed_ms': 0.0,
    'is_safe': true, // Assume safe until told otherwise
    'timestamp': '',
  });

  final sub = db.ref('stream_logs/$_sessionId').orderByChild('timestamp').limitToLast(1).onValue.listen((event) {
    if (event.snapshot.exists && event.snapshot.value != null) {
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      final lastLogKey = data.keys.first;
      final lastLog = Map<String, dynamic>.from(data[lastLogKey] as Map);
      
      // As per GEMINI.md, the app should listen for stream_logs/{session_id}/{timestamp}
      // and the data contains flow_state.
      if (lastLog['flow_state'] == 'PREP') {
         final Map<String, dynamic> typedMap = {
          'wind_speed_ms': lastLog['wind_speed_ms'] ?? 0.0,
          'is_safe': lastLog['is_safe'] ?? false,
          'timestamp': lastLog['timestamp'] ?? '',
        };
        if (!controller.isClosed) {
          controller.add(typedMap);
        }
      }
    }
  }, onError: (error) {
    if (!controller.isClosed) {
      controller.addError(error);
    }
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});

// Provider to manage the Auto-Tare state
final autoTareProvider = StateProvider<bool>((ref) => false);
