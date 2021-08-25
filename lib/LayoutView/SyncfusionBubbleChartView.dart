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
      ChartData(0, 38, 667),
      ChartData(1, 34, 274),
      ChartData(2, 52, 272),
      ChartData(3, 40, 240),
      ChartData(4, 34, 235),
      ChartData(5, 52, 235),
      ChartData(6, 40, 227),
      ChartData(7, 40, 180),
      ChartData(8, 34, 175),
      ChartData(9, 52, 150)
    ];

    return Scaffold(
        body: Center(
            child: Container(
                child: SfCartesianChart(
                    primaryXAxis: NumericAxis(),
                    series: <ChartSeries>[
                      // Renders bubble chart
                      BubbleSeries<ChartData, int>(
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
  final int x;
  final double y;
  final double size;
}
