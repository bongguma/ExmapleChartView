import 'package:flutter/material.dart';
import 'package:multi_charts/multi_charts.dart';

class RadarChartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Radar 차트예제'),
      ),
      body: RadarCharts(),
    );
  }
}

class RadarCharts extends StatefulWidget {
  @override
  RadarChartViewState createState() => RadarChartViewState();
}

class RadarChartViewState extends State<RadarCharts> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      margin: EdgeInsets.only(left: 5.0, right: 5.0),
      child: Column(children: [
        Container(
          width: 450,
          height: 450,
          //Radar Chart
          child: RadarChart(
            strokeColor: Colors.grey[300],
            labelColor: Colors.grey,
            values: [1, 2, 4, 7, 9, 0, 6, 0],
            labels: [
              "아",
              "아아",
              "아아아",
              "아아아아",
              "아아아아아",
              "아아아아아아",
              "아아아아아아아",
              "아아아아아아아아",
            ],
            maxValue: 12,
            fillColor: Colors.blue,
            chartRadiusFactor: 0.7,
          ),
        ),
        //Pie Chart
      ]
      ),
    );
  }
}