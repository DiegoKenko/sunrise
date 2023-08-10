import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sunrise/interface/controllers/auth/firebase_auth_controller.dart';
import 'package:sunrise/interface/states/auth_state.dart';
import 'package:sunrise/entity/lover_entity.dart';
import 'package:sunrise/usecase/auth/auth_usecase.dart';

class AuthController extends ValueNotifier<AuthState> {
  final AuthUsecase authUsecase = AuthUsecase();
  AuthController() : super(AuthUninitializedState());

  Future<bool> login() async {
    value = AuthLoadingState();
    bool ret = await authUsecase.authenticate().fold((success) {
      value = AuthAuthenticatedState(success);
      return true;
    }, (error) {
      value = AuthErrorState(error.toString());
      return false;
    });
    return ret;
  }

  Future<void> logout() async {
    value = AuthLoadingState();
    try {
      await FirebaseAuthController().signOut();
      value = AuthUnauthenticatedState();
    } catch (e) {
      value = AuthErrorState(e.toString());
    }
  }

  LoverEntity get lover {
    if (value is AuthAuthenticatedState) {
      return (value as AuthAuthenticatedState).lover;
    } else {
      return LoverEntity.empty();
    }
  }

  bool isAuth() {
    return value is AuthAuthenticatedState;
  }
}
