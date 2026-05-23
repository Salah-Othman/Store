part of 'auth_cubit.dart';

@immutable
abstract class AuthState{}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {}

class AuthPasswordUpdated extends AuthState {}

class AuthAccountDeleted extends AuthState {}

class AuthPasswordResetEmailSent extends AuthState {
  AuthPasswordResetEmailSent(this.email);

  final String email;
}

class AuthError extends AuthState {
  AuthError(this.message);

  final String message;
}
