import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotifications {
  FirebaseNotifications._();

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> init() async {
    // Android 13+ will prompt; iOS also needs permission.
    await _messaging.requestPermission();

    // Save initial token (if logged in).
    final token = await _messaging.getToken();
    await _saveTokenForCurrentUser(token);

    // Keep token updated.
    _messaging.onTokenRefresh.listen((t) async {
      await _saveTokenForCurrentUser(t);
    });
  }

  static Future<void> _saveTokenForCurrentUser(String? token) async {
    if (token == null || token.isEmpty) return;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance.collection('users').doc(uid).set(
      {'fcmToken': token},
      SetOptions(merge: true),
    );
  }
}

