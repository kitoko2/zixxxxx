// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentification {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User?> loginWithGmail() async {
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      UserCredential userCredential =
          await auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User?> loginWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login(
      permissions: ['public_profile', 'email'],
    );
    final token = result.accessToken!.token;
    print(token);

    try {
      AuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(token);
      UserCredential userCredential =
          await auth.signInWithCredential(facebookAuthCredential);
      return userCredential.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  signOut() async {
    try {
      await auth.signOut();
      if (await _googleSignIn.isSignedIn()) {
        googleSignOut();
      }
      facebookSignOut();
    } catch (e) {
      print(e.toString());
    }
  }

  facebookSignOut() {
    try {
      FacebookAuth.instance.logOut();
    } catch (e) {
      print("FACEBOOK SIGN OUT");
      print(e);
    }
  }

  googleSignOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      print("GOOGLE SIGN OUT");

      print(e.toString());
    }
  }
}
