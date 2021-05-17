import 'package:sometrend_charttest/Data/ChartData.dart';

class ChartDataList {
  List<ChartData> chartDataList;

  ChartDataList(
      {this.chartDataList});

  factory ChartDataList.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> itemJson = json['item'];
    List<dynamic> rowDataJson = itemJson['rows'];
    List<ChartData> chartDataList = [];
    ChartData chartData;
    rowDataJson.forEach((element) {
      Map<String, dynamic> chartDataJson = element;

      chartData = new ChartData();
      chartData.date = chartDataJson['date'] as String;
      chartData.weekOfYear = chartDataJson['weekOfYear'] as int;
      chartData.baseMonth = chartDataJson['baseMonth'] as int;
      chartData.weekOfMonth = chartDataJson['weekOfMonth'] as int;
      chartData.frequency = chartDataJson['frequency'] as int;
      chartDataList.add(chartData);
    });
    return ChartDataList(
      chartDataList: chartDataList,
    );
  }
}
