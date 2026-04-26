import 'package:TR/core/errors/error_handler.dart';
import 'package:TR/core/localization/app_localizations.dart';
import 'package:TR/core/services/firebase_service.dart';
import 'package:TR/core/utils/form_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({FirebaseService? firebaseService})
      : _firebaseService = firebaseService ?? FirebaseServiceImpl(FirebaseFirestore.instance),
        super(AuthInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseService _firebaseService;

  Future<void> signIn({required String email, required String password}) async {
    final emailError = FormValidator.validateEmail(email);
    if (emailError != null) {
      emit(AuthError(emailError));
      return;
    }

    final passwordError = FormValidator.validatePassword(password);
    if (passwordError != null) {
      emit(AuthError(passwordError));
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
      final failure = ErrorHandler.handleException(e);
      emit(AuthError(failure.message));
    } catch (e) {
      emit(AuthError(ErrorHandler.unexpectedError));
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    final nameError = FormValidator.validateName(name);
    if (nameError != null) {
      emit(AuthError(nameError));
      return;
    }

    final emailError = FormValidator.validateEmail(email);
    if (emailError != null) {
      emit(AuthError(emailError));
      return;
    }

    final passwordError = FormValidator.validatePassword(password);
    if (passwordError != null) {
      emit(AuthError(passwordError));
      return;
    }

    final phoneError = FormValidator.validatePhone(phoneNumber);
    if (phoneError != null) {
      emit(AuthError(phoneError));
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
        await _firebaseService.addDocument('users', {
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
      final failure = ErrorHandler.handleException(e);
      emit(AuthError(failure.message));
    } catch (e) {
      emit(AuthError(ErrorHandler.unexpectedError));
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    final emailError = FormValidator.validateEmail(email);
    if (emailError != null) {
      emit(AuthError(emailError));
      return;
    }

    emit(AuthLoading());

    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      emit(AuthPasswordResetEmailSent(email.trim()));
    } on FirebaseAuthException catch (e) {
      final failure = ErrorHandler.handleException(e);
      emit(AuthError(failure.message));
    } catch (e) {
      emit(AuthError(ErrorHandler.unexpectedError));
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
}