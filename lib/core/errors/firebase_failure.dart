import 'package:firebase_auth/firebase_auth.dart';

class FirebaseFailure {
  final String message;
  final String code;

  FirebaseFailure({required this.message, required this.code});

  factory FirebaseFailure.fromFirebaseException(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return FirebaseFailure(
          message: "Access denied. You don't have permission to view this.",
          code: e.code,
        );
      case 'unavailable':
        return FirebaseFailure(
          message: "Service is currently unavailable. Check your internet.",
          code: e.code,
        );
      case 'not-found':
        return FirebaseFailure(
          message: "The requested data was not found.",
          code: e.code,
        );
      case 'deadline-exceeded':
        return FirebaseFailure(
          message: "The connection timed out. Please try again.",
          code: e.code,
        );
      case 'already-exists':
        return FirebaseFailure(
          message: "This item already exists.",
          code: e.code,
        );
      case 'cancelled':
        return FirebaseFailure(
          message: "Operation was cancelled.",
          code: e.code,
        );
      case 'invalid-argument':
        return FirebaseFailure(
          message: "Invalid data provided.",
          code: e.code,
        );
      default:
        return FirebaseFailure(
          message: "A database error occurred. Please try again later.",
          code: e.code,
        );
    }
  }

  factory FirebaseFailure.fromAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return FirebaseFailure(
          message: "The email address is not valid.",
          code: e.code,
        );
      case 'user-disabled':
        return FirebaseFailure(
          message: "This account has been disabled.",
          code: e.code,
        );
      case 'user-not-found':
        return FirebaseFailure(
          message: "No account found with this email.",
          code: e.code,
        );
      case 'wrong-password':
        return FirebaseFailure(
          message: "Incorrect password. Please try again.",
          code: e.code,
        );
      case 'invalid-credential':
        return FirebaseFailure(
          message: "Invalid login credentials. Please check and try again.",
          code: e.code,
        );
      case 'email-already-in-use':
        return FirebaseFailure(
          message: "This email is already registered.",
          code: e.code,
        );
      case 'operation-not-allowed':
        return FirebaseFailure(
          message: "This sign-in method is not enabled.",
          code: e.code,
        );
      case 'weak-password':
        return FirebaseFailure(
          message: "Password is too weak. Use at least 6 characters.",
          code: e.code,
        );
      case 'network-request-failed':
        return FirebaseFailure(
          message: "Network error. Check your internet connection.",
          code: e.code,
        );
      case 'too-many-requests':
        return FirebaseFailure(
          message: "Too many attempts. Please wait and try again.",
          code: e.code,
        );
      case 'requires-recent-login':
        return FirebaseFailure(
          message: "Please sign in again to complete this action.",
          code: e.code,
        );
      default:
        return FirebaseFailure(
          message: e.message ?? "An authentication error occurred.",
          code: e.code,
        );
    }
  }

  factory FirebaseFailure.fromFirebaseExceptionDefault(FirebaseException e) {
    return FirebaseFailure(
      message: e.message ?? "A Firebase error occurred. Please try again.",
      code: e.code,
    );
  }
}