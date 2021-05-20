import 'dart:convert';
import 'package:bubble_chart/bubble_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sometrend_charttest/Data/ChartData.dart';
import 'package:sometrend_charttest/Data/ChartDataList.d\art';
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
  Future<ChartDataList> futureChartDataList;
  DateLib dateLib = new DateLib();
  List<ChartData> chartDataList = [];
  SearchChartDateType _searchChartDateType = SearchChartDateType.DAY;
  List<FlSpot> spots = [];
  String _startDate = '', _endDate = '';

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  final bubbles = BubbleNode.node(
    padding: 0,
    children: [
      // BubbleNode.node(
      //   padding: 30,
      //   children: [
      //     BubbleNode.leaf(
      //       options: BubbleOptions(
      //         color: Colors.brown,
      //       ),
      //       value: 2583,
      //     ),
      //     BubbleNode.leaf(
      //       options: BubbleOptions(
      //         color: Colors.brown,
      //       ),
      //       value: 4159,
      //     ),
      //     BubbleNode.leaf(
      //       options: BubbleOptions(
      //         color: Colors.brown,
      //       ),
      //       value: 4159,
      //     ),
      //   ],
      // ),
      BubbleNode.leaf(
        value: 4159,
      ),
      BubbleNode.leaf(
        value: 2074,
      ),
      BubbleNode.leaf(
        value: 119,
      ),
      BubbleNode.leaf(
        value: 2074,
      ),
      BubbleNode.leaf(
        value: 2074,
      ),
      BubbleNode.leaf(
        value: 2074,
      ),
      BubbleNode.leaf(
        value: 2074,
        options: BubbleOptions(
          child: Text('테스트')
        )
      ),
    ],
  );

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
    chartDataList = [];

    futureChartDataList.then((value) {
      value.chartDataList.forEach((chartData) {
        chartDataList.add(chartData);
      });

      setState(() {
        spots = chartDataList.asMap().entries.map((e) {
          return FlSpot(e.key.toDouble(), e.value.frequency.toDouble());
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BubbleChartLayout(
        root: bubbles,
      ),
    );
  }
}

Future<ChartDataList> fetchChartDataList(
    String startDate, String endDate) async {
  print('startDate :: ' + startDate + 'endDate :: ' + endDate);
  String uriStr =
      "https://some.co.kr/sometrend/analysis/trend/transition?startDate=" +
          startDate +
          "&endDate=" +
          endDate +
          "&topN=100&period=0&keyword=%EB%B9%84%ED%8A%B8%EC%BD%94%EC%9D%B8&analysisMonths=0&categorySetName=TSN&excludeRT=true&sources=blog";
  Uri uri = Uri.parse(uriStr);
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return ChartDataList.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load ChartData');
  }
}
