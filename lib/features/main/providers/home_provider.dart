import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pericare/core/firebase/firebase_providers.dart';

// TODO: Replace with actual user management from an auth provider
const String _patientId = "user_001"; 

final patientNameProvider = FutureProvider<String>((ref) async {
  final firestore = ref.watch(firestoreProvider);
  // TODO: This should use the actual logged-in user's ID
  final doc = await firestore.collection('patients').doc(_patientId).get();
  return doc.data()?['name'] ?? '환자';
});

final deviceMacProvider = FutureProvider<String?>((ref) async {
  final firestore = ref.watch(firestoreProvider);
  final doc = await firestore.collection('patients').doc(_patientId).get();
  return doc.data()?['device_mac'];
});

final deviceStatusProvider = StreamProvider<Map<String, dynamic>>((ref) async* {
  final firestore = ref.watch(firestoreProvider);
  final macAddress = await ref.watch(deviceMacProvider.future);

  if (macAddress == null) {
    yield {'status': 'Unregistered', 'battery': 0};
    return;
  }

  yield* firestore.collection('devices').doc(macAddress).snapshots().map((doc) {
    if (!doc.exists || doc.data() == null) {
      return {'status': 'Offline', 'battery': 0};
    }
    final data = doc.data()!;
    final lastHeartbeat = data['last_heartbeat'] as Timestamp?;
    final isOnline = lastHeartbeat != null &&
        DateTime.now().difference(lastHeartbeat.toDate()).inMinutes < 2;
    
    return {
      'status': isOnline ? 'Online' : 'Offline',
      'battery': data['battery_level'] ?? 0,
    };
  });
});


// TODO: Implement today's summary logic by fetching 'sessions' subcollection
final todaySummaryProvider = Provider((ref) {
  // This would involve a more complex query to filter sessions by date
  return {
    'completed_sessions': 0,
    'total_uf': 0.0,
  };
});
