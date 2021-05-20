import 'package:sometrend_charttest/Data/RankData.dart';

class BubbleChartData {
  String date;
  int weekOfYear;
  List<RankData> ranks;
  int baseMonth;
  int weekOfMonth;

  BubbleChartData(
      {this.date,
        this.weekOfYear,
        this.ranks,
        this.baseMonth,
        this.weekOfMonth});

}
