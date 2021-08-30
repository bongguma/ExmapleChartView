import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:provider/provider.dart';
import 'package:sometrend_charttest/Auth/GoogleLoginAuthProvider.dart';
import 'package:sometrend_charttest/Auth/KakaoLoginAuthProvider.dart';
import 'package:sometrend_charttest/Data/CounterProvider.dart';
import 'package:sometrend_charttest/Data/Type/LoginType.dart';
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
                      color: theme.primaryBlackTextColor,
                      fontWeight: FontWeight.bold))
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

        isKakaoTalkInstall
            ? KakaoLoginAuthProvider().loginWithTalk(context)
            : KakaoLoginAuthProvider().loginWithKakao(context);
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
                      color: theme.primaryBlackTextColor,
                      fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
      onTap: () async {
        await GoogleLoginAuthProvider().signInWithGoogle().then((value) {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => MenuView(
          //             loginType: LoginType.GOOGLE)
          //     ));

          Get.toNamed('/menu', arguments: {"loginType": LoginType.GOOGLE});
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
