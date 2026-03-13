import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pericare/core/firebase/firebase_providers.dart';

// In a real app, these values would be passed from the previous screens/providers.
final finalNetUfProvider = Provider<double>((ref) => 250.0);
final targetUfProvider = Provider<double>((ref) => 250.0); // From patient's prescription
final finalDrainVolumeProvider = Provider<double>((ref) => 2250.0);
final finalFillVolumeProvider = Provider<double>((ref) => 2000.0);
final isEnvironmentSafeProvider = Provider<bool>((ref) => true);

// TODO: Replace with actual session and patient IDs
const String _sessionId = "session_123";
const String _patientId = "user_001";

final sessionSaveProvider = FutureProvider.autoDispose<void>((ref) async {
  final firestore = ref.watch(firestoreProvider);
  
  final sessionData = {
    'start_time': Timestamp.now(), // This should be the actual start time
    'end_time': Timestamp.now(),
    'session_status': 'DONE',
    'total_drain': ref.watch(finalDrainVolumeProvider),
    'total_fill': ref.watch(finalFillVolumeProvider),
    'net_uf': ref.watch(finalNetUfProvider),
    'is_safe_env': ref.watch(isEnvironmentSafeProvider),
    'is_manual': false, // Assuming not manual for now
  };

  // This provider will be called/listened to on the result screen to trigger the save.
  await firestore
      .collection('patients')
      .doc(_patientId)
      .collection('sessions')
      .doc(_sessionId)
      .set(sessionData, SetOptions(merge: true));
});
