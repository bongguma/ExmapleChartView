import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SyncfusionBubbleChartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Syncfusion 차트예제'),
      ),
      body: BubbleChart(),
    );
  }
}

class BubbleChart extends StatefulWidget {
  @override
  BubbleChartViewState createState() => BubbleChartViewState();
}

class BubbleChartViewState extends State<BubbleChart> {
  var now = new DateTime.now();
  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData(now, 35, 0.32),
      ChartData(now.add(new Duration(days: -1)), 38, 0.21),
      ChartData(now.add(new Duration(days: -2)), 34, 0.38),
      ChartData(now.add(new Duration(days: -3)), 52, 0.29),
      ChartData(now.add(new Duration(days: -4)), 40, 0.34)
    ];

    return Scaffold(
        body: Center(
            child: Container(
                child: SfCartesianChart(
                    primaryXAxis: DateTimeAxis(),
                    series: <ChartSeries>[
                      // Renders bubble chart
                      BubbleSeries<ChartData, DateTime>(
                          dataSource: chartData,
                          sizeValueMapper: (ChartData sales, _) => sales.size,
                          xValueMapper: (ChartData sales, _) => sales.x,
                          yValueMapper: (ChartData sales, _) => sales.y
                      )
                    ]
                )
            )
        )
    );
  }
}


class ChartData {
  ChartData(this.x, this.y, this.size);
  final DateTime x;
  final double y;
  final double size;
}