import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sometrend_charttest/BubbleChartExampleView.dart';
import 'package:sometrend_charttest/Data/CounterProvider.dart';
import 'package:sometrend_charttest/LineChartExampleView.dart';
import 'package:sometrend_charttest/RadarChartView.dart';
import 'package:sometrend_charttest/SyncfusionBubbleChartView.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Stream<int> countStream(int to) async* {
    for (int i = 1; i <= to; i++) {
      print('counsStream : $i');
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
              child: Text('Syncfusion 차트 예제'),
              onPressed: () {
                // chart 라이브러리 사용해서 예제 진행-
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SyncfusionBubbleChartView()));
              },
            ),
            ElevatedButton(
              child: Text('radar 차트 예제'),
              onPressed: () {
                // chart 라이브러리 사용해서 예제 진행-
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RadarChartView()));
              },
            ),
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
