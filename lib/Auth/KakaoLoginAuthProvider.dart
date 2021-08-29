import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:sometrend_charttest/Data/KakaoTalkAccount.dart';
import 'package:get/get.dart';
import 'package:sometrend_charttest/Data/Type/LoginType.dart';
class KakaoLoginAuthProvider with ChangeNotifier {

  // 카카오톡이 깔려있지 않을 경우, 아이디 비밀번호 입력
  loginWithKakao(context) async {
    try {
      var code = await AuthCodeClient.instance.request();
      await issueAccessToken(context, code);
    } catch (e) {
      print('loginWithKakao :: ' + e.toString());
    }
  }

  // 카카오톡이 깔려 있을 경우, 간편 로그인 시작
  loginWithTalk(context) async {
    try {
      var code = await AuthCodeClient.instance.requestWithTalk();
      await issueAccessToken(context, code);
    } catch (e) {
      print('loginWithTalk :: ' + e.toString());
    }
  }

  issueAccessToken(context, String authCode) async {
    try {
      var token = await AuthApi.instance.issueAccessToken(authCode);
      AccessTokenStore.instance.toStore(token);
      print('token :: ' + token.accessToken);

      // 카카오톡으로 token 값을 받아올 경우,
      if (token.accessToken.isNotEmpty) {
        KakaoLoginAuthProvider().kakaoUserData(context).then((kakaoTalkAccount) {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => MenuView(
          //         loginType: LoginType.KAKAO,
          //         kakaoTalkAccount: kakaoTalkAccount,
          //       ),
          //     ));
          Get.toNamed('/menu', arguments: {"loginType" : LoginType.KAKAO, "kakaoTalkAccount": kakaoTalkAccount});
        });
      }
    } catch (e) {
      print('issueAccessToken :: ' + e.toString());
    }
  }

  // 카카오 로그인 성공 시, userData 가져오기
  Future<KakaoTalkAcounnt> kakaoUserData(context) async {
    var kakaoTalkAccount = new KakaoTalkAcounnt(); // 카카오톡 로그인 시, 로그인 유저 데이터 객체

    try {
      User user = await UserApi.instance.me();
      Account account = user.kakaoAccount;
      Profile profile = account.profile;

      kakaoTalkAccount.email = account.email;
      kakaoTalkAccount.nickname = profile.nickname;
      kakaoTalkAccount.thumbnailImageUrl = profile.thumbnailImageUrl;
      kakaoTalkAccount.profileImageUrl = profile.profileImageUrl;

      // do anything you want with user instance
    } on KakaoAuthException catch (e) {
      if (e.error == ApiErrorCause.INVALID_TOKEN) {
        // access token has expired and cannot be refrsehd. access tokens are already cleared here
        Navigator.of(context)
            .pushReplacementNamed('/login'); // redirect to login page
      }
    } catch (e) {
      // other api or client-side errors
    }

    return kakaoTalkAccount;
  }

}