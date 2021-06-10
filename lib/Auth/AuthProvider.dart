import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _logIn(String method, dynamic token) async{
    try{
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

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      final GoogleSignInAccount _googleSignInAccount =
      await _googleSignIn.signIn();
      if (_googleSignInAccount != null) {
        final GoogleSignInAuthentication googleAuth =
        await _googleSignInAccount.authentication;
        if (googleAuth.accessToken != null && googleAuth.idToken != null) {
          _logIn(
              "google",
              GoogleAuthProvider.getCredential(
                  idToken: googleAuth.idToken,
                  accessToken: googleAuth.accessToken));
        }
      }
    } catch (e) {
      print(e);
    }
  }
}