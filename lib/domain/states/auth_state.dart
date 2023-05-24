import 'package:sunrise/model/model_lover.dart';

abstract class AuthState {}

class AuthUninitialized extends AuthState {}

class AuthAuthenticated extends AuthState {
  final Lover lover;
  AuthAuthenticated(this.lover);
}

class AuthUnauthenticated extends AuthState {}

class AuthLoading extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
