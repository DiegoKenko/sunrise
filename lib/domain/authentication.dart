import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sunrise/data/data_provider_lover.dart';
import 'package:sunrise/model/model_lover.dart';

class FirebaseAuthentication {
  final FirebaseAuth _instance = FirebaseAuth.instance;

  Stream<Lover?> authStateChanges() async* {
    Lover? lover;

    await for (final user in _instance.userChanges()) {
      if (user != null) {
        lover = await DataProviderLover().getId(user.uid);
        yield lover;
      }
    }
  }

  User? get currentUser => _instance.currentUser;

  Future<void> signOut() async {
    await _instance.signOut();
    await _googleSignOut();
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
