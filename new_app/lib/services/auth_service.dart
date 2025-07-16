import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  User? get currentUser => _auth.currentUser;

  // Stream that emits the current user when authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges().asyncMap((user) async {
        if (user != null) {
          // Save user login state
          final prefs = await _prefs;
          await prefs.setString('user_uid', user.uid);
        }
        return user;
      });

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await _prefs;
    return prefs.getString('user_uid') != null || _auth.currentUser != null;
  }

  // Get current user UID
  Future<String?> getCurrentUserId() async {
    final prefs = await _prefs;
    return prefs.getString('user_uid') ?? _auth.currentUser?.uid;
  }

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (result.user != null) {
        final prefs = await _prefs;
        await prefs.setString('user_uid', result.user!.uid);
      }
      
      notifyListeners();
      return {'success': true, 'user': result.user};
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred';
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        errorMessage = 'Invalid email or password';
      } else if (e.code == 'user-disabled') {
        errorMessage = 'This account has been disabled';
      }
      return {'success': false, 'error': errorMessage};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (result.user != null) {
        await _firestore.collection('users').doc(result.user!.uid).set({
          'uid': result.user!.uid,
          'name': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      notifyListeners();
      return {'success': true, 'user': result.user};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<void> signOut() async {
    try {
      final prefs = await _prefs;
      await prefs.remove('user_uid');
      await _auth.signOut();
      notifyListeners();
    } catch (e) {
      debugPrint('Error signing out: $e');
    }
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }
  }
}
