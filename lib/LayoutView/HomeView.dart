import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:provider/provider.dart';
import 'package:sometrend_charttest/Auth/AuthProvider.dart';
import 'package:sometrend_charttest/Data/CounterProvider.dart';
import 'package:sometrend_charttest/Data/KakaoTalkAccount.dart';
import 'package:sometrend_charttest/Data/Type/LoginType.dart';
import 'package:sometrend_charttest/LayoutView/MenuView.dart';
import 'package:sometrend_charttest/theme/ThemeFactory.dart';

class HomeView extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // CounterProvider를 바라본다는 뜻으로 MyHomePage 자식들은 다 CounterProvider에 접근이 가능
      // 데이터통신으로 계속해서 회원정보를 받아오는 것보다 프로바이더를 이용하여 회원정보를 이동시키는 방법이 더 효율적 -
      // Consumer 또는 Provider.of<CounterProvider>(context)를 통해서 접근이 가능
      home: ChangeNotifierProvider<CounterProvider>(
        create: (context) => CounterProvider(),
        child: Home(title: 'Flutter Demo Home Page'),
      ),
      // FirebaseAnalyticsObserver는 GA (google Analytics) 확인을 위해 추가해준 로직으로,
      // Analytics 라이브러리 또한 pubspec 붙여주어야 라이브러리 사용이 가능
      navigatorObservers: [
        // 파이어베이스 애널리틱스 ( 앱 데이터 로깅 및 이벤트 로깅을 확인해볼 수 있음 )
        // FirebaseAnalyticsObserver(analytics: analytics),
      ],
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState

    initKakaoTalkInstalled();

    // firebase 관련 주석 진행 상태
    // firebase FCM 예제
    // firebaseCloudMessaging_Listeners();
  }

  bool isKakaoTalkInstall = true; // 카카오톡이 설치가 되어있는지 확인

  initKakaoTalkInstalled() async {
    final installed = await isKakaoTalkInstalled();

    setState(() {
      isKakaoTalkInstall = installed;
    });
  }

  issueAccessToken(String authCode) async {
    try {
      var token = await AuthApi.instance.issueAccessToken(authCode);
      AccessTokenStore.instance.toStore(token);
      print('token :: ' + token.accessToken);

      // 카카오톡으로 token 값을 받아올 경우,
      if (token.accessToken.isNotEmpty) {
        kakaoUserData().then((kakaoTalkAccount) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MenuView(
                  loginType: LoginType.KAKAO,
                  kakaoTalkAccount: kakaoTalkAccount,
                ),
              ));
        });
      }
    } catch (e) {
      print('issueAccessToken :: ' + e.toString());
    }
  }

  // 카카오톡이 깔려있지 않을 경우, 아이디 비밀번호 입력
  loginWithKakao() async {
    try {
      var code = await AuthCodeClient.instance.request();
      await issueAccessToken(code);
    } catch (e) {
      print('loginWithKakao :: ' + e.toString());
    }
  }

  // 카카오톡이 깔려 있을 경우, 간편 로그인 시작
  loginWithTalk() async {
    try {
      var code = await AuthCodeClient.instance.requestWithTalk();
      await issueAccessToken(code);
    } catch (e) {
      print('loginWithTalk :: ' + e.toString());
    }
  }

  // 카카오 로그인 성공 시, userData 가져오기
  Future<KakaoTalkAcounnt> kakaoUserData() async {
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

  // void firebaseCloudMessaging_Listeners() {
  //   if (Platform.isIOS) iOS_Permission();
  //
  //   _firebaseMessaging.getToken().then((token) {
  //     print('token:' + token);
  //   });
  //
  //   _firebaseMessaging.configure(
  //     onMessage: (Map<String, dynamic> message) async {
  //       print('on message $message');
  //     },
  //     onResume: (Map<String, dynamic> message) async {
  //       print('on resume $message');
  //     },
  //     onLaunch: (Map<String, dynamic> message) async {
  //       print('on launch $message');
  //     },
  //   );
  // }

  // void iOS_Permission() {
  //   _firebaseMessaging.requestNotificationPermissions(
  //       IosNotificationSettings(sound: true, badge: true, alert: true));
  //   _firebaseMessaging.onIosSettingsRegistered
  //       .listen((IosNotificationSettings settings) {
  //     print("Settings registered: $settings");
  //   });
  // }

  Widget kakaoLoginBtn(theme) {
    return InkWell(
      child: Container(
        width: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: theme.primaryYellowColor,
            boxShadow: [
              BoxShadow(
                color: theme.primaryGreyBgColor.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, 0),
              ),
            ]),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 20,
                height: 20,
                child: Image.asset('asset/kakaoLogo.png'),
              ),
              SizedBox(width: 5),
              Text('Kakao로 간편한 시작',
                  style: TextStyle(
                      color: theme.primaryBlackTextColor, fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
      onTap: () {
        // kakaoMap test 시, 진행했던 로직
        // chart 라이브러리 사용해서 예제 진행-
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => KakaoMapTestView()));

        isKakaoTalkInstall ? loginWithTalk() : loginWithKakao();
      },
    );
  }

  Widget googleLoginBtn(theme) {
    return InkWell(
      child: Container(
        width: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: theme.secondaryBgColor,
            boxShadow: [
              BoxShadow(
                color: theme.primaryGreyBgColor.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, 0),
              ),
            ]),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 20,
                height: 20,
                child: Image.asset('asset/googleLogo.png'),
              ),
              SizedBox(width: 5),
              Text('Google로 간편한 시작',
                  style: TextStyle(
                      color: theme.primaryBlackTextColor, fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
      onTap: () async {
        await AuthProvider().signInWithGoogle().then((value) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MenuView(
                      loginType: LoginType.GOOGLE)
              ));
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    var theme = new ThemeFactory.of(context).theme;

    return Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(left: 12.0, right: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                kakaoLoginBtn(theme),
                SizedBox(height: 15.0),
                googleLoginBtn(theme),
              ],
            ),
          ),
        ));
  }
}
