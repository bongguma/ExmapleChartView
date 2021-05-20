import 'dart:convert';

import 'package:sometrend_charttest/Data/BubbleChartData.dart';
import 'package:sometrend_charttest/Data/RankData.dart';

class BubbleChartDataList {
  List<BubbleChartData> bubbleChartDataList;

  BubbleChartDataList(
      {this.bubbleChartDataList});

  factory BubbleChartDataList.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> itemJson = json['item'];
    List<dynamic> rowDataJson = itemJson['rows'];
    List<BubbleChartData> bubbleChartDataList = [];
    BubbleChartData bubbleChartData;
    rowDataJson.forEach((element) {
      Map<String, dynamic> chartDataJson = element;
      bubbleChartData = new BubbleChartData();
      bubbleChartData.date = chartDataJson['date'] as String;
      bubbleChartData.weekOfYear = chartDataJson['weekOfYear'] as int;
      bubbleChartData.baseMonth = chartDataJson['baseMonth'] as int;
      bubbleChartData.weekOfMonth = chartDataJson['weekOfMonth'] as int;

      // 버블 데이터
      List<dynamic> data = chartDataJson['ranks'];
      RankData rankData = new RankData();
      List<RankData> rankDataList = [];
      Map<String, dynamic> rankDataMap;
      data.forEach((element) {
        rankDataMap = element;
        rankData.rank = rankDataMap['rank'] as int;
        rankData.label = rankDataMap['label'] as String;
        rankData.polarity = rankDataMap['polarity'] as String;
        rankData.frequency = rankDataMap['frequency'] as int;
        rankDataList.add(rankData);
        rankData = new RankData();

      });

      bubbleChartData.ranks = rankDataList;
      bubbleChartDataList.add(bubbleChartData);
    });
    return BubbleChartDataList(
      bubbleChartDataList: bubbleChartDataList,
    );
  }
}
