import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sunrise/datasource/lover/lover_load_datasource.dart';
import 'package:sunrise/entity/lover_entity.dart';

class FirebaseAuthController {
  FirebaseAuthController();
  final LoverLoadDatasource loadDatasource = LoverLoadDatasource();
  final FirebaseAuth _instance = FirebaseAuth.instance;

  Stream<LoverEntity?> authStateChanges() async* {
    LoverEntity? lover;

    await for (final user in _instance.userChanges()) {
      if (user != null) {
        lover = await loadDatasource(user.uid)
            .fold((success) => success, (failure) => null);

        yield lover;
      }
    }
  }

  User? get currentUser => _instance.currentUser;

  Future<void> signOut() async {
    if (currentUser != null) {
      await _googleSignOut();
      await _instance.signOut();
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    if (googleUser == null) {
      throw Exception('Google user is null');
    } else {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
  }

  Future<void> _googleSignOut() async {
    await GoogleSignIn().signOut();
  }
}
