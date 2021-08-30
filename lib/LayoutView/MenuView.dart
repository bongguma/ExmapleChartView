import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sometrend_charttest/LayoutView/BubbleChartExampleView.dart';
import 'package:sometrend_charttest/LayoutView/DartGrammerTestView.dart';
import 'package:sometrend_charttest/Data/Type/LoginType.dart';
import 'package:sometrend_charttest/LayoutView/LineChartExampleView.dart';
import 'package:sometrend_charttest/LayoutView/MindmapGraphView.dart';
import 'package:sometrend_charttest/LayoutView/RadarChartView.dart';
import 'package:sometrend_charttest/LayoutView/SyncfusionBubbleChartView.dart';
import 'package:sometrend_charttest/LayoutView/defaultLayoutView/DefalutAppBar.dart';
import 'package:sometrend_charttest/theme/ThemeFactory.dart';

import '../Data/AccountData.dart';

class MenuView extends StatelessWidget {
  final LoginType loginType = Get.arguments['loginType'];
  final AccountData accountData = Get.arguments['accountData'];

  MenuView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppbar(
        isBackBtn: false,
        loginType: loginType,
      ),
      body: Menu(
        loginType: loginType,
        accountData: accountData,
      ),
    );
  }
}

class Menu extends StatefulWidget {
  final LoginType loginType;
  final AccountData accountData;

  Menu({Key key, @required this.loginType, @required this.accountData})
      : super(key: key);

  @override
  MenuState createState() => MenuState();
}

// 카카오톡 프로필 정보
Widget KakaoProfileView(widget) {
  return Row(
    children: [
      CircleAvatar(
          radius: 25,
          backgroundImage:
              widget.kakaoTalkAccount.profileImageUrl.toString().isNotEmpty
                  ? NetworkImage(widget.kakaoTalkAccount.profileImageUrl)
                  : AssetImage("assets/images/testImage.jpg")),
      SizedBox(width: 10),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${widget.kakaoTalkAccount.nickname}'),
          SizedBox(height: 5),
          Text('${widget.kakaoTalkAccount.email}'),
        ],
      )
    ],
  );
}

class MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    var theme = new ThemeFactory.of(context).theme;

    return Scaffold(
      backgroundColor: theme.secondaryBgColor,
      body: Padding(
        padding:
            EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0, bottom: 10.0),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              !widget.accountData.isBlank
                  ? KakaoProfileView(widget)
                  : Container(),
              Flexible(
                flex: 1,
                child: Column(
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
                                builder: (context) =>
                                    BubbleChartExampleView()));
                      },
                    ),
                    ElevatedButton(
                      child: Text('Syncfusion 차트 예제'),
                      onPressed: () {
                        // chart 라이브러리 사용해서 예제 진행-
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SyncfusionBubbleChartView()));
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
                      },
                    ),
                    ElevatedButton(
                      child: Text('google 로그인예제'),
                      onPressed: () {
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
              ),
            ],
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
