import 'dart:convert';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sometrend_charttest/Data/ChartData.dart';
import 'package:sometrend_charttest/Data/ChartDataList.dart';
import 'package:sometrend_charttest/Data/Type/SearchChartDateType.dart';
import 'package:sometrend_charttest/Lib/DateLib.dart';

class LineChartExampleView extends StatelessWidget {
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

class ChartViewState extends State<ChartView> {   // 혼자 화면을 출력할 수 없어서 state 클래스를 상속 받아줌
  Future<ChartDataList> futureChartDataList;
  DateLib dateLib = new DateLib();
  List<ChartData> chartDataList = [];
  List<int> chartDataFrequencyList = [];
  SearchChartDateType _searchChartDateType = SearchChartDateType.DAY;
  List<FlSpot> spots = [];
  String _startDate = '', _endDate = '';
  int _maxY = 0;

  // List<Color> gradientColors = [
  //   const Color(0xff23b6e6),
  //   const Color(0xff02d39a),
  // ];

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
    chartDataFrequencyList = [];


    futureChartDataList.then((value) {
      value.chartDataList.forEach((chartData) {
        chartDataList.add(chartData);
        chartDataFrequencyList.add(chartData.frequency);
      });

      setState(() {
        spots = chartDataList.asMap().entries.map((e) {
          return FlSpot(e.key.toDouble(), e.value.frequency.toDouble());
        }).toList();
        _maxY = (chartDataFrequencyList.reduce(max)/100).ceil() * 100;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
          children: [Row(
                children: [
                  Flexible(
                    child: ListTile(
                      title: Text('7일'),
                      leading: Radio(
                        value: SearchChartDateType.DAY,
                        groupValue: _searchChartDateType,
                        onChanged: (value) {
                          setState(() {
                            _searchChartDateType = value;
                            searchDateChartData();
                          });
                        },
                      ),
                    ),
                  ),
                  Flexible(
                    child: ListTile(
                      title: Text('1개월'),
                      leading: Radio(
                        value: SearchChartDateType.MONTH,
                        groupValue: _searchChartDateType,
                        onChanged: (value) {
                          setState(() {
                            _searchChartDateType = value;
                            searchDateChartData();
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            Column(
              children: <Widget>[
                Container(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                          padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                          child: SizedBox(
                            width: 1000,
                            child: LineChart(
                                mainChart()
                            ),
                          ) ),
                    )),
              ],
            ),
          ],
        ));
  }

  LineChartData mainChart() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey[200],
            strokeWidth: 0.3,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.grey[200],
            strokeWidth: 0.3,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 12),
          getTitles: (value) {
            if (_searchChartDateType == SearchChartDateType.DAY) {
              if (value.toInt() % 2 == 0 && value.toInt() < 7) {
                return chartDataList[value.toInt()].date.toString();
              }
            } else if (_searchChartDateType == SearchChartDateType.MONTH  && value.toInt() < 31) {
              if (value.toInt() % 4 == 0) {
                return chartDataList[value.toInt()].date.toString();
              }
            }
            return "";
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          getTitles: (value) {
            if (value.toInt() % 100 == 0) {
              return value.toString();
            }
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 0.3)),
      minX: 0,
      maxX: spots.length.toDouble() - 1.0,
      minY: 0,
      maxY: _maxY.toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: spots.isEmpty ? [FlSpot(0, 0)] : spots,
          isCurved: false,
          colors: [Colors.white],
          barWidth: 1,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: [Colors.blue[300]],
          ),
        ),
      ],
    );
  }
}

Future<ChartDataList> fetchChartDataList(
    String startDate, String endDate) async {
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
    // return ChartDataList.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load ChartData');
  }
}
