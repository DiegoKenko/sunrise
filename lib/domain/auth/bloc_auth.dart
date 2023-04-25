import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sunrise/datasource/data_provider_lover.dart';
import 'package:sunrise/domain/auth/authentication.dart';
import 'package:sunrise/model/model_lover.dart';

class AuthService extends ChangeNotifier {
  Lover? lover;
  AuthService();

  Future<void> authenticate() async {
    final UserCredential userCredencial =
        await FirebaseAuthentication().signInWithGoogle();

    if (userCredencial.user != null) {
      lover = await DataProviderLover().getUser(userCredencial.user!);
      await DataProviderLover().update(lover!);
    } else {
      _register(userCredencial);
    }
  }

  Future<void> _register(UserCredential userCredencial) async {
    lover = Lover(
      email: userCredencial.user!.email!,
      name: userCredencial.user!.displayName!,
      id: userCredencial.user!.uid,
      photoURL: userCredencial.user!.photoURL!,
    );
    await DataProviderLover().create(lover!);
  }

  Future<void> logout() async {
    lover = null;
    await FirebaseAuthentication().signOut();
  }

  bool isAuth() {
    return lover != null;
  }
}
