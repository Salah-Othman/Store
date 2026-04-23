import 'package:TR/core/localization/app_localizations.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signIn({required String email, required String password}) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      emit(AuthError(_localized.fillAllRequiredFields));
      return;
    }

    emit(AuthLoading());

    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      emit(AuthAuthenticated());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_mapAuthError(e)));
    } catch (_) {
      emit(AuthError(_localized.authUnknownError));
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    if (name.trim().isEmpty ||
        email.trim().isEmpty ||
        password.trim().isEmpty ||
        phoneNumber.trim().isEmpty) {
      emit(AuthError(_localized.fillAllRequiredFields));
      return;
    }

    emit(AuthLoading());

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await credential.user?.updateDisplayName(name.trim());

      if (credential.user != null) {
        await _firestore.collection('users').doc(credential.user!.uid).set({
          'name': name.trim(),
          'email': email.trim(),
          'phoneNumber': phoneNumber.trim(),
          'role': 'user',
          'isAdmin': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      emit(AuthAuthenticated());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_mapAuthError(e)));
    } catch (_) {
      emit(AuthError(_localized.authUnknownError));
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    if (email.trim().isEmpty) {
      emit(AuthError(_localized.emailRequired));
      return;
    }

    emit(AuthLoading());

    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      emit(AuthPasswordResetEmailSent(email.trim()));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_mapAuthError(e)));
    } catch (_) {
      emit(AuthError(_localized.authUnknownError));
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    emit(AuthInitial());
  }

  AppLocalizations get _localized {
    final settingsBox = Hive.box('settings_box');
    final languageCode =
        settingsBox.get('appLanguage', defaultValue: 'en') as String;
    return AppLocalizations.fromLanguageCode(languageCode);
  }

  String _mapAuthError(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return _localized.invalidEmail;
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return _localized.invalidLoginCredentials;
      case 'email-already-in-use':
        return _localized.emailAlreadyInUse;
      case 'weak-password':
        return _localized.weakPassword;
      case 'network-request-failed':
        return _localized.networkRequestFailed;
      case 'too-many-requests':
        return _localized.tooManyRequests;
      default:
        return exception.message ?? _localized.authUnknownError;
    }
  }
}
