import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleLoginAuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> logIn(String method, dynamic token) async {
    try {
      notifyListeners();
      switch (method) {
        case "google":
          _auth.signInWithCredential(token);
          break;
      }
    } catch (e) {
      // error = e;
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  /* 구글 로그인 연동 함수 */
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      final GoogleSignInAccount _googleSignInAccount =
          await _googleSignIn.signIn();
      if (_googleSignInAccount != null) {
        final GoogleSignInAuthentication googleAuth =
            await _googleSignInAccount.authentication;
        if (googleAuth.accessToken != null && googleAuth.idToken != null) {
          logIn(
              "google",
              GoogleAuthProvider.credential(
                  idToken: googleAuth.idToken,
                  accessToken: googleAuth.accessToken));
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> logOut() async {
    await Firebase.initializeApp();

    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
