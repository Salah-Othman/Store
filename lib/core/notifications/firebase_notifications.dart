import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotifications {
  FirebaseNotifications._();

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static String? _lastKnownToken;
  static Future<void> _tokenSaveQueue = Future.value();
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    // Android 13+ will prompt; iOS also needs permission.
    await _messaging.requestPermission();

    // Save initial token (even if not logged in yet).
    _lastKnownToken = await _messaging.getToken();
    await _enqueueSaveForCurrentUser(_lastKnownToken);

    // Keep token updated.
    _messaging.onTokenRefresh.listen((t) {
      _lastKnownToken = t;
      _enqueueSaveForCurrentUser(t);
    });

    // Bug 1 fix: when user logs in, ensure token is saved even if it never refreshes.
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) return;
      _enqueueSaveForCurrentUser(_lastKnownToken);
    });
  }

  static Future<void> _enqueueSaveForCurrentUser(String? token) {
    // Bug 2 fix: serialize saves to avoid races/desync.
    _tokenSaveQueue = _tokenSaveQueue
        .catchError((_) {})
        .then((_) => _saveTokenForCurrentUser(token));
    return _tokenSaveQueue;
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

