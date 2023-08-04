import 'package:sunrise/entity/lover_entity.dart';

abstract class AuthState {}

class AuthUninitializedState extends AuthState {}

class AuthAuthenticatedState extends AuthState {
  final LoverEntity lover;
  AuthAuthenticatedState(this.lover);
}

class AuthUnauthenticatedState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthErrorState extends AuthState {
  final String message;
  AuthErrorState(this.message);
}
