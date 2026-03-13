import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// In a real app, this would be set at the end of the drain phase from the previous screen's provider.
final finalDrainWeightProvider = Provider<double>((ref) => 2250.0);

// The prescribed amount of fluid in a new bag. This comes from the patient's prescription.
final prescribedFillVolumeProvider = Provider<double>((ref) => 2000.0);

// This provider simulates the live weight on the scale during the Fill phase.
// In a real app, this would listen to the Firebase Realtime DB.
final fillWeightProvider = StreamProvider<double>((ref) {
  final startWeight = ref.watch(prescribedFillVolumeProvider);
  // Simulate weight decreasing over 40 seconds.
  return Stream.periodic(const Duration(seconds: 1), (i) {
    final weight = startWeight - i * 50;
    return weight < 0 ? 0.0 : weight;
  }).take(41);
});

// A provider that calculates the volume of fluid infused into the patient.
final injectedVolumeProvider = Provider<double>((ref) {
  final startWeight = ref.watch(prescribedFillVolumeProvider);
  // Get the latest weight from the stream, default to the start weight if not available.
  final currentWeight = ref.watch(fillWeightProvider).asData?.value ?? startWeight;
  
  // The injected volume is the difference from the start.
  return startWeight - currentWeight;
});
