import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pericare/core/firebase/firebase_providers.dart';
import 'package:collection/collection.dart';

// TODO: The session ID should be dynamically set when a session starts.
const String _sessionId = "session_123";

class WeightDataPoint {
  final DateTime timestamp;
  final double weight;

  WeightDataPoint(this.timestamp, this.weight);
}

final sessionDrainProvider = StreamProvider<List<WeightDataPoint>>((ref) {
  final db = ref.watch(realtimeDbProvider);
  final controller = StreamController<List<WeightDataPoint>>();
  final List<WeightDataPoint> allPoints = [];

  final sub = db.ref('stream_logs/$_sessionId').onValue.listen((event) {
    if (event.snapshot.exists && event.snapshot.value != null) {
      allPoints.clear();
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      
      data.forEach((key, value) {
        final log = Map<String, dynamic>.from(value as Map);
        if (log['type'] == 'WEIGHT') {
          // Assuming timestamp is in the format "2026-03-07T20:30:00Z"
          // Or it could be a unix timestamp. Let's assume it's a string for now.
          // In a real scenario, robust parsing is needed.
          final timestamp = DateTime.tryParse(log['timestamp'] ?? '') ?? DateTime.now();
          allPoints.add(WeightDataPoint(timestamp, (log['value'] as num).toDouble()));
        }
      });

      // Sort points by timestamp
      allPoints.sortBy((d) => d.timestamp);
      
      if (!controller.isClosed) {
        controller.add(List.from(allPoints));
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

// TODO: Implement completion logic: weight change < 5g/min for 3 consecutive readings.
final isDrainCompleteProvider = StateProvider<bool>((ref) => false);

// This would come from the patient's prescription
final targetDrainVolumeProvider = Provider<double>((ref) => 2000.0);
