import 'dart:convert';
import 'package:bubble_chart/bubble_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sometrend_charttest/Data/BubbleChartDataList.dart';
import 'package:sometrend_charttest/Data/ChartData.dart';
import 'package:sometrend_charttest/Data/ChartDataList.dart';
import 'package:sometrend_charttest/Data/RankData.dart';
import 'package:sometrend_charttest/Data/Type/SearchChartDateType.dart';
import 'package:sometrend_charttest/Lib/DateLib.dart';

class BubbleChartExampleView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('차트예제'),
      ),
      body: ChartView(),
    );
  }
}

class ChartView extends StatefulWidget {
  @override
  ChartViewState createState() => ChartViewState();
}

class ChartViewState extends State<ChartView> {
  Future<BubbleChartDataList> futureChartDataList;
  DateLib dateLib = new DateLib();
  List<RankData> rankDataList = [];
  SearchChartDateType _searchChartDateType = SearchChartDateType.DAY;
  String _startDate = '', _endDate = '';
  int _totalNegativePercent = 0, _totalNeutralPercent = 0, _totalPositivePercent = 0;

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  bool showAvg = false;

  @override
  void initState() {
    super.initState();

    _endDate = dateLib.todayBeforeOneDateStr();
    searchDateChartData();
  }

  searchDateChartData() {
    if (_searchChartDateType == SearchChartDateType.DAY) {
      _startDate = dateLib.beforeDay();
    } else if (_searchChartDateType == SearchChartDateType.MONTH) {
      _startDate = dateLib.beforeMonthLastDay();
    }
    futureChartDataList = fetchChartDataList(_startDate, _endDate);

    futureChartDataList.then((value) {
      setState(() {
        value.bubbleChartDataList.forEach((bubbleChart) {
          rankDataList = bubbleChart.ranks;
          int _totalNegativeFrquency = 0, _totalNeutralFrquency = 0, _totalPositiveFrquency = 0, _totalFrequency = 0;
          bubbleChart.ranks.forEach((rankData) {
            _totalFrequency += rankData.frequency;
            // 부정일 때
            if(rankData.polarity == "negative"){
              _totalNegativeFrquency += rankData.frequency;
            } else if(rankData.polarity == "neutral"){
              _totalNeutralFrquency += rankData.frequency;
            } else if(rankData.polarity == "positive"){
              _totalPositiveFrquency += rankData.frequency;
            }
          });
          _totalNegativePercent = (_totalNegativeFrquency / _totalFrequency * 100.0).round();
          _totalNeutralPercent = (_totalNeutralFrquency / _totalFrequency * 100.0).round();
          _totalPositivePercent = (_totalPositiveFrquency / _totalFrequency * 100.0).round();
        });

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if(rankDataList.isNotEmpty) {
      return Scaffold(
        body: BubbleChartLayout(
          root: BubbleNode.node(
            padding: 0,
            children: List.generate(rankDataList.length, (index) {
              if (rankDataList[index].polarity == "negative") {
                return BubbleNode.leaf(
                    value: rankDataList[index].frequency.toInt(),
                    options: BubbleOptions(
                        child: Text(rankDataList[index].label),
                        color: Colors.red
                    )
                );
              } else if (rankDataList[index].polarity == "neutral") {
                return BubbleNode.leaf(
                    value: rankDataList[index].frequency.toInt(),
                    options: BubbleOptions(
                        child: Text(rankDataList[index].label),
                        color: Colors.greenAccent
                    )
                );
              } else if (rankDataList[index].polarity == "positive") {
                return BubbleNode.leaf(
                    value: rankDataList[index].frequency.toInt(),
                    options: BubbleOptions(
                        child: Text(rankDataList[index].label),
                        color: Colors.blue
                    )
                );
              }
            }),
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Container(),
      );
    }
  }
}

Future<BubbleChartDataList> fetchChartDataList(
    String startDate, String endDate) async {
  print('startDate :: ' + startDate + 'endDate :: ' + endDate);
  String uriStr =
      "https://some.co.kr/sometrend/analysis/trend/sentiment-period?topN=10&period=1&keyword=%EB%B9%84%ED%8A%B8%EC%BD%94%EC%9D%B8&endDate=20210516&startDate=20210510&analysisMonths=0&categorySetName=TSN&excludeRT=true&sources=blog&sources=news";
  Uri uri = Uri.parse(uriStr);
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return BubbleChartDataList.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  } else {
    throw Exception('Failed to load ChartData');
  }
}
