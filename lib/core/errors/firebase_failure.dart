import 'package:firebase_core/firebase_core.dart';

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
      default:
        return FirebaseFailure(
          message: "A database error occurred. Please try again later.",
          code: e.code,
        );
    }
  }
}