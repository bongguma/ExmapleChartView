import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sometrend_charttest/Auth/AuthProvider.dart';
import 'package:sometrend_charttest/BubbleChartExampleView.dart';
import 'package:sometrend_charttest/DartGrammerTestView.dart';
import 'package:sometrend_charttest/Data/CounterProvider.dart';
import 'package:sometrend_charttest/LineChartExampleView.dart';
import 'package:sometrend_charttest/MindmapGraphView.dart';
import 'package:sometrend_charttest/RadarChartView.dart';
import 'package:sometrend_charttest/SyncfusionBubbleChartView.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();    // main 메소드에서 비동기 메소드 사용할 때 반드시 넣어줘야한다.
  await
  runApp(MyApp());
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
        child:
        MyHomePage(title: 'Flutter Demo Home Page'),
      ),
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

    // Stream 예제
    // var stream = countStream(10);
    // stream.listen((int stream) {
    //   print('stream :: ' + stream.toString());
    // });

    // firebase FCM 예제
    firebaseCloudMessaging_Listeners();
  }

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token){
      print('token:'+token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true)
    );
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings)
    {
      print("Settings registered: $settings");
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => RadarChartView()));
                    // 메소드 실행을 위해 Notify를 받지 않는 Provider of를 지정
                    print('Provider.of<CounterProvider>(context).getCount().toString(); :: ' + Provider.of<CounterProvider>(context, listen: false).getCount().toString());
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
                    await AuthProvider().signInWithGoogle().then((value) =>
                        print('value :: '));
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
              child:
              Image.asset('image/testImage.jpg', width: 150, height: 150, fit: BoxFit.fitHeight)
            )
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
