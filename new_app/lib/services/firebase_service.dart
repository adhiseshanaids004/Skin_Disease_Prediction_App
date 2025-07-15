import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/scan_result_model.dart';
import '../services/auth_service.dart';

class FirebaseService {
  static const String _scansCollection = 'scans';
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  bool get isAuthenticated => _authService.currentUser != null;

  // Save scan result to Firebase under user's document
  Future<void> saveScanResult(ScanResult result) async {
    if (!isAuthenticated) {
      throw Exception('User must be authenticated to save scan results');
    }

    try {
      final user = _authService.currentUser!;
      await _db
          .collection('users')
          .doc(user.uid)
          .collection(_scansCollection)
          .add({
        'disease': result.disease,
        'stage': result.stage,
        'description': result.description,
        'remedy': result.remedy,
        'precautions': result.precautions,
        'date': result.date,
      });
    } catch (e) {
      throw Exception('Failed to save scan result: $e');
    }
  }

  // Get scan history from Firebase for current user
  Stream<List<ScanResult>> getScanHistory() {
    if (!isAuthenticated) {
      return Stream.value([]);
    }

    final user = _authService.currentUser!;

    return _db
        .collection('users')
        .doc(user.uid)
        .collection(_scansCollection)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ScanResult.fromMap(doc.data()!))
            .toList());
  }

  // Delete a scan result
  Future<void> deleteScan(String id) async {
    if (!isAuthenticated) {
      throw Exception('User must be authenticated to delete scan results');
    }

    try {
      final user = _authService.currentUser!;
      await _db
          .collection('users')
          .doc(user.uid)
          .collection(_scansCollection)
          .doc(id)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete scan: $e');
    }
  }
}
