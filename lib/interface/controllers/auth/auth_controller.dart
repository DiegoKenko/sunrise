import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sunrise/interface/controllers/auth/firebase_auth_controller.dart';
import 'package:sunrise/interface/states/auth_state.dart';
import 'package:sunrise/entity/lover_entity.dart';
import 'package:sunrise/usecase/lover/lover_load_usecase.dart';

class AuthController extends ValueNotifier<AuthState> {
  AuthController() : super(AuthUninitializedState());



 

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
