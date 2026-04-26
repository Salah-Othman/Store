part of 'auth_cubit.dart';

@immutable
abstract class AuthState{}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {}

class AuthPasswordResetEmailSent extends AuthState {
  AuthPasswordResetEmailSent(this.email);

  final String email;
}

class AuthError extends AuthState {
  AuthError(this.message);

  final String message;
}
