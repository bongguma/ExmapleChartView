import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sometrend_charttest/Data/AccountData.dart';

class GoogleLoginAuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var googleAccount = new AccountData();

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
  Future<void> signInWithGoogle(context) async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        // 사용자 데이터 받아오는 부분
        googleUserData(context, googleSignInAccount).then((accountData) {
          googleAccount = accountData;
        });

        final GoogleSignInAuthentication googleAuth =
            await googleSignInAccount.authentication;
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

  // 구글 로그인 성공 시, userData 가져오기
  Future<AccountData> googleUserData(context, googleSignInAccount) async {
    var googleAccount = new AccountData(); // 카카오톡 로그인 시, 로그인 유저 데이터 객체

    try {
      googleAccount.email = googleSignInAccount.email;
      googleAccount.nickname = googleSignInAccount.displayName;
      googleAccount.profileImageUrl = googleSignInAccount.photoUrl;

      // do anything you want with user instance
    } catch (e) {
      // other api or client-side errors
    }

    return googleAccount;
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
