import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class AuthFailure extends Failure {
  final String code;
  const AuthFailure(super.message, {this.code = ''});
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class FirebaseFailure extends Failure {
  final String code;
  const FirebaseFailure(super.message, {this.code = ''});

  factory FirebaseFailure.fromFirebaseException(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return FirebaseFailure("Access denied. You don't have permission to view this.", code: e.code);
      case 'unavailable':
        return FirebaseFailure("Service is currently unavailable. Check your internet.", code: e.code);
      case 'not-found':
        return FirebaseFailure("The requested data was not found.", code: e.code);
      case 'deadline-exceeded':
        return FirebaseFailure("The connection timed out. Please try again.", code: e.code);
      case 'already-exists':
        return FirebaseFailure("This item already exists.", code: e.code);
      case 'cancelled':
        return FirebaseFailure("Operation was cancelled.", code: e.code);
      case 'invalid-argument':
        return FirebaseFailure("Invalid data provided.", code: e.code);
      case 'network-error':
        return FirebaseFailure("Network error. Check your internet connection.", code: e.code);
      default:
        return FirebaseFailure("A database error occurred. Please try again later.", code: e.code);
    }
  }

  factory FirebaseFailure.fromAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return FirebaseFailure("The email address is not valid.", code: e.code);
      case 'user-disabled':
        return FirebaseFailure("This account has been disabled.", code: e.code);
      case 'user-not-found':
        return FirebaseFailure("No account found with this email.", code: e.code);
      case 'wrong-password':
        return FirebaseFailure("Incorrect password. Please try again.", code: e.code);
      case 'invalid-credential':
        return FirebaseFailure("Invalid login credentials. Please check and try again.", code: e.code);
      case 'email-already-in-use':
        return FirebaseFailure("This email is already registered.", code: e.code);
      case 'operation-not-allowed':
        return FirebaseFailure("This sign-in method is not enabled.", code: e.code);
      case 'weak-password':
        return FirebaseFailure("Password is too weak. Use at least 6 characters.", code: e.code);
      case 'network-request-failed':
        return FirebaseFailure("Network error. Check your internet connection.", code: e.code);
      case 'too-many-requests':
        return FirebaseFailure("Too many attempts. Please wait and try again.", code: e.code);
      case 'requires-recent-login':
        return FirebaseFailure("Please sign in again to complete this action.", code: e.code);
      default:
        return FirebaseFailure(e.message ?? "An authentication error occurred.", code: e.code);
    }
  }
}