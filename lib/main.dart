import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:provider/provider.dart';
import 'package:sometrend_charttest/Auth/GoogleLoginAuthProvider.dart';
import 'package:sometrend_charttest/Data/CounterProvider.dart';
import 'package:sometrend_charttest/Data/KakaoTalkAccount.dart';
import 'package:sometrend_charttest/Data/Type/LoginType.dart';
import 'package:sometrend_charttest/LayoutView/HomeView.dart';
import 'package:sometrend_charttest/LayoutView/MenuView.dart';
import 'package:sometrend_charttest/theme/ThemeFactory.dart';

// 현재 파이어베이스와 카카오 플러터 연동 버전 의존성이 맞지 않아서 파이어베이스 패키지 주석처리 진행해놓은 상태
// final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
// final FirebaseAnalytics analytics = FirebaseAnalytics();

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // main 메소드에서 비동기 메소드 사용할 때 반드시 넣어줘야한다.
  await Firebase.initializeApp();

  KakaoContext.clientId = "60a43a215471a5fc217d190f574b3391";
  KakaoContext.javascriptClientId = "bd8926bcafd8c32bf4aac0b856255c99";

  await runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState

    initControllers();
  }

  void initControllers() {
    // Get.put(LoginController());
  }

  List<GetPage> renderPages() {
    return [
      GetPage(
        name: '/',
        page: () => HomeView(),
        transition: Transition.noTransition,
        // binding: BindingsBuilder(() {
        //   Get.put(CounterController());
        // }),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      getPages: renderPages(),
    );
  }
}
