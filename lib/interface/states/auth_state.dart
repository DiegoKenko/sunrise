import 'package:sunrise/entity/lover_entity.dart';

abstract class AuthState {}

class AuthUninitialized extends AuthState {}

class AuthAuthenticated extends AuthState {
  final LoverEntity lover;
  AuthAuthenticated(this.lover);
}

class AuthUnauthenticated extends AuthState {}

class AuthLoading extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
