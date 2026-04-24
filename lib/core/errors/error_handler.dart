import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

class ErrorHandler {
  static const String unexpectedError = "An unexpected error occurred. Please try again.";
  static const String networkError = "Network error. Check your internet connection.";
  static const String serverError = "Server error. Please try again later.";

  static dynamic handleException(dynamic exception) {
    if (exception is FirebaseAuthException) {
      return _handleAuthException(exception);
    } else if (exception is FirebaseException) {
      return _handleFirebaseException(exception);
    } else if (exception is SocketException) {
      return NetworkFailure(networkError);
    } else if (exception is FormatException) {
      return ServerFailure("Data format error. Please try again.");
    }
    return Failure(unexpectedError);
  }

  static FirebaseFailure _handleFirebaseException(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return FirebaseFailure(
          message: "Access denied.",
          code: e.code,
        );
      case 'unavailable':
        return FirebaseFailure(
          message: "Service unavailable. Check internet.",
          code: e.code,
        );
      case 'not-found':
        return FirebaseFailure(
          message: "Data not found.",
          code: e.code,
        );
      case 'deadline-exceeded':
        return FirebaseFailure(
          message: "Request timed out.",
          code: e.code,
        );
      case 'already-exists':
        return FirebaseFailure(
          message: "Item already exists.",
          code: e.code,
        );
      case 'cancelled':
        return FirebaseFailure(
          message: "Operation cancelled.",
          code: e.code,
        );
      case 'invalid-argument':
        return FirebaseFailure(
          message: "Invalid data.",
          code: e.code,
        );
      case 'network-error':
        return FirebaseFailure(
          message: networkError,
          code: e.code,
        );
      default:
        return FirebaseFailure(
          message: serverError,
          code: e.code,
        );
    }
  }

  static FirebaseFailure _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return FirebaseFailure(message: "Invalid email address.", code: e.code);
      case 'user-disabled':
        return FirebaseFailure(message: "Account disabled.", code: e.code);
      case 'user-not-found':
        return FirebaseFailure(message: "Account not found.", code: e.code);
      case 'wrong-password':
        return FirebaseFailure(message: "Incorrect password.", code: e.code);
      case 'invalid-credential':
        return FirebaseFailure(message: "Invalid credentials.", code: e.code);
      case 'email-already-in-use':
        return FirebaseFailure(message: "Email already registered.", code: e.code);
      case 'operation-not-allowed':
        return FirebaseFailure(message: "Sign-in not allowed.", code: e.code);
      case 'weak-password':
        return FirebaseFailure(message: "Password too weak.", code: e.code);
      case 'network-request-failed':
        return FirebaseFailure(message: networkError, code: e.code);
      case 'too-many-requests':
        return FirebaseFailure(message: "Too many attempts. Wait and try.", code: e.code);
      case 'requires-recent-login':
        return FirebaseFailure(message: "Sign in again.", code: e.code);
      default:
        return FirebaseFailure(message: e.message ?? unexpectedError, code: e.code);
    }
  }
}

class FirebaseFailure {
  final String message;
  final String code;

  FirebaseFailure({required this.message, required this.code});
}

class NetworkFailure {
  final String message;
  NetworkFailure(this.message);
}

class ServerFailure {
  final String message;
  ServerFailure(this.message);
}

class Failure {
  final String message;
  Failure(this.message);
}