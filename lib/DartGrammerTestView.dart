import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DartGrammerTestView extends StatelessWidget{

  VoidCallback clickBtn;

  DartGrammerTestView({
    Key key,
    // @required this.clickBtn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DartGrammerTest(),
    );
  }
}

final List<String> imgList = [
  'http://reasley.com/wp-content/uploads/2020/04/one.jpg',
  'http://reasley.com/wp-content/uploads/2020/04/two.jpg',
  'http://reasley.com/wp-content/uploads/2020/04/three.jpg'
];

class DartGrammerTest extends StatefulWidget {
  DartGrammerTest ({Key key}) : super(key: key);

  @override
  DartGrammerTestViewState createState() => DartGrammerTestViewState();
}


class DartGrammerTestViewState extends State<DartGrammerTest> {
  PageController pageController;
  int currentPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = new PageController(
      initialPage: currentPage,
      keepPage: false,
      viewportFraction: 0.5,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            color: Colors.red,
            height : 250,
            child:  Swiper(
              autoplay: false,
              scale: 0.9,
              // viewportFraction: 0.8,  // 양 옆 이미지 보여지는 method
              // control: SwiperControl(), // 양 옆 컨트롤 method
              pagination: SwiperPagination(
                  alignment: Alignment.bottomCenter
              ),
              itemCount: imgList.length,
              itemBuilder: (BuildContext context, int index){
                return Image.network(imgList[index]);
              },
            )
        ),

        Container(
          color: Colors.amber,
          height : 600,
          child:
          WebView(
            initialUrl: "https://m.naver.com",
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ),
      ],
    );
  }

}