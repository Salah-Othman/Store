import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'failures.dart';

class ErrorHandler {
  static const String unexpectedError = "An unexpected error occurred. Please try again.";
  static const String networkError = "Network error. Check your internet connection.";
  static const String serverError = "Server error. Please try again later.";

  static Failure handleException(dynamic exception) {
    if (exception is FirebaseAuthException) {
      return FirebaseFailure.fromAuthException(exception);
    } else if (exception is FirebaseException) {
      return FirebaseFailure.fromFirebaseException(exception);
    } else if (exception is SocketException) {
      return NetworkFailure(networkError);
    } else if (exception is FormatException) {
      return ServerFailure("Data format error. Please try again.");
    }
    return ServerFailure(unexpectedError);
  }
}