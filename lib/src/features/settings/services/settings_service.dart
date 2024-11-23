import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Future<Map<String, dynamic>?> getUserDetails() async {
    final user = currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    return doc.data();
  }

  String get userEmail => currentUser?.email ?? 'Not logged in';
  String get userName => currentUser?.displayName ?? 'Anonymous';

  Future<void> updateUserDetails({
    String? displayName,
    String? email,
  }) async {
    final user = currentUser;
    if (user == null) throw Exception('User not logged in');

    if (displayName != null) {
      await user.updateDisplayName(displayName);
      await _firestore.collection('users').doc(user.uid).update({
        'username': displayName,
      });
    }

    if (email != null && email != user.email) {
      await user.verifyBeforeUpdateEmail(email);
      await _firestore.collection('users').doc(user.uid).update({
        'email': email,
      });
    }
  }
}