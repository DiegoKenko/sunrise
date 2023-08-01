import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sunrise/datasource/data_provider_lover.dart';
import 'package:sunrise/domain/auth/authentication.dart';
import 'package:sunrise/domain/states/auth_state.dart';
import 'package:sunrise/entity/lover_entity.dart';

class AuthService extends ValueNotifier<AuthState> {
  AuthService() : super(AuthUninitialized());

  Future<void> authenticate() async {
    final UserCredential userCredencial =
        await FirebaseAuthentication().signInWithGoogle();

    try {
      if (userCredencial.user != null) {
        LoverEntity lover =
            await DataProviderLover().getUser(userCredencial.user!);
        await DataProviderLover().update(lover);
        value = AuthAuthenticated(lover);
      } else {
        _register(userCredencial);
      }
    } catch (e) {
      value = AuthError(e.toString());
    }
  }

  Future<void> _register(UserCredential userCredencial) async {
    try {
      LoverEntity lover = LoverEntity(
        email: userCredencial.user!.email!,
        name: userCredencial.user!.displayName!,
        id: userCredencial.user!.uid,
        photoURL: userCredencial.user!.photoURL!,
      );
      await DataProviderLover().create(lover);
      value = AuthAuthenticated(lover);
    } catch (e) {
      value = AuthError(e.toString());
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuthentication().signOut();
      value = AuthUnauthenticated();
    } catch (e) {
      value = AuthError(e.toString());
    }
  }

  LoverEntity get lover {
    if (value is AuthAuthenticated) {
      return (value as AuthAuthenticated).lover;
    } else {
      return LoverEntity.empty();
    }
  }

  bool isAuth() {
    return value is AuthAuthenticated;
  }
}
