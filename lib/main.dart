import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:provider/provider.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_analytics/observer.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sometrend_charttest/Auth/AuthProvider.dart';
import 'package:sometrend_charttest/BubbleChartExampleView.dart';
import 'package:sometrend_charttest/DartGrammerTestView.dart';
import 'package:sometrend_charttest/Data/CounterProvider.dart';
import 'package:sometrend_charttest/KakaoMapTestView.dart';
import 'package:sometrend_charttest/LineChartExampleView.dart';
import 'package:sometrend_charttest/MindmapGraphView.dart';
import 'package:sometrend_charttest/RadarChartView.dart';
import 'package:sometrend_charttest/SyncfusionBubbleChartView.dart';


// 현재 파이어베이스와 카카오 플러터 연동 버전 의존성이 맞지 않아서 파이어베이스 패키지 주석처리 진행해놓은 상태
// final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
// final FirebaseAnalytics analytics = FirebaseAnalytics();

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // main 메소드에서 비동기 메소드 사용할 때 반드시 넣어줘야한다.

  KakaoContext.clientId = "60a43a215471a5fc217d190f574b3391";
  KakaoContext.javascriptClientId = "bd8926bcafd8c32bf4aac0b856255c99";
  await runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        child: MyHomePage(title: 'Flutter Demo Home Page'),
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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Stream<int> countStream(int to) async* {
    for (int i = 1; i <= to; i++) {
      print('countStream : $i');
      yield i;
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    initKakaoTalkInstalled();
    // Strea 예제
    // var stream = countStream(10);
    // stream.listen((int stream) {
    //   print('stream :: ' + stream.toString());
    // });

    // firebase 관련 주석 진행 상태
    // firebase FCM 예제
    // firebaseCloudMessaging_Listeners();
  }

  initKakaoTalkInstalled() async {
    final installed = await isKakaoTalkInstalled();

    setState(() {
      isKakaoTalkInstall = installed;
    });
  }

  bool isKakaoTalkInstall = true;

  issueAccessToken(String authCode) async {
    try{
      var token = await AuthApi.instance.issueAccessToken(authCode);
      AccessTokenStore.instance.toStore(token);
      print('token :: ' + token.accessToken);

      // Navigator.push(context, MaterialPageRoute(builder: (context) => Home(),
      // ));
    } catch (e) {
      print('issueAccessToken :: ' + e.toString());
    }
  }

  loginWithKakao() async {
    try{
      var code = await AuthCodeClient.instance.request();
      await issueAccessToken(code);
    } catch (e) {
      print('loginWithKakao :: ' + e.toString());
    }
  }

  loginWithTalk() async {
    try{
      var code = await AuthCodeClient.instance.requestWithTalk();
      await issueAccessToken(code);
    } catch(e) {
      print('loginWithTalk :: ' + e.toString());
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text('라인차트 예제'),
                  onPressed: () {
                    // chart 라이브러리 사용해서 예제 진행-
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LineChartExampleView()));
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  child: Text('버블차트 예제'),
                  onPressed: () {
                    // chart 라이브러리 사용해서 예제 진행-
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BubbleChartExampleView()));
                  },
                ),
                ElevatedButton(
                  child: Text('kakao로그인 연동'),
                  onPressed: () {
                    // kakaoMap test 시, 진행했던 로직
                    // chart 라이브러리 사용해서 예제 진행-
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => KakaoMapTestView()));

                    isKakaoTalkInstall ? loginWithTalk() : loginWithKakao();
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text('Syncfusion 차트 예제'),
                  onPressed: () {
                    // chart 라이브러리 사용해서 예제 진행-
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SyncfusionBubbleChartView()));
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  child: Text('radar 차트 예제'),
                  onPressed: () {
                    // chart 라이브러리 사용해서 예제 진행-
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RadarChartView()));
                    // 메소드 실행을 위해 Notify를 받지 않는 Provider of를 지정
                    print(
                        'Provider.of<CounterProvider>(context).getCount().toString(); :: ' +
                            Provider.of<CounterProvider>(context, listen: false)
                                .getCount()
                                .toString());
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text('google 로그인예제'),
                  onPressed: () async {
                    // await AuthProvider()
                    //     .signInWithGoogle()
                    //     .then((value) => print('value :: '));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DartGrammerTestView()));
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  child: Text('mindmap 그래프 예제'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MindmapGraphView()));
                  },
                ),
              ],
            ),
            Container(
                color: Colors.yellow,
                child: Image.asset('asset/testImage.jpg',
                    width: 150, height: 150, fit: BoxFit.fitHeight))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
