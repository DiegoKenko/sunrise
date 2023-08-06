import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sunrise/datasource/data_provider_lover.dart';
import 'package:sunrise/interface/controllers/auth/firebase_auth_controller.dart';
import 'package:sunrise/interface/states/auth_state.dart';
import 'package:sunrise/entity/lover_entity.dart';

class AuthController extends ValueNotifier<AuthState> {
  AuthController() : super(AuthUninitializedState());

  Future<void> authenticate() async {
    final UserCredential userCredencial =
        await FirebaseAuthController().signInWithGoogle();
    value = AuthLoadingState();

    try {
      if (userCredencial.user != null) {
        LoverEntity lover =
            await DataProviderLover().getUser(userCredencial.user!);
        await DataProviderLover().update(lover);
        value = AuthAuthenticatedState(lover);
      } else {
        _register(userCredencial);
      }
    } catch (e) {
      value = AuthErrorState(e.toString());
    }
  }

  Future<void> _register(UserCredential userCredencial) async {
    value = AuthLoadingState();
    try {
      LoverEntity lover = LoverEntity(
        email: userCredencial.user!.email!,
        name: userCredencial.user!.displayName!,
        id: userCredencial.user!.uid,
        photoURL: userCredencial.user!.photoURL!,
      );
      await DataProviderLover().create(lover);
      value = AuthAuthenticatedState(lover);
    } catch (e) {
      value = AuthErrorState(e.toString());
    }
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
