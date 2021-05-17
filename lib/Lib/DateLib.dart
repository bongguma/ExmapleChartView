import 'package:intl/intl.dart';
import 'package:date_utils/date_utils.dart';

class DateLib {
  /* 오늘날 구하기 */
  String todayDateStr() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyyMMdd');

    String formattedDate = formatter.format(now);
    return formattedDate;
  }

  /* 오늘날 기준 전날 구하기 */
  String todayBeforeOneDateStr() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyyMMdd');
    now =now.add(new Duration(days: -1));

    String formattedDate = formatter.format(now);
    return formattedDate;
  }

  /* 오늘날 이번달 마지막 날 구하기 */
  String monthLastDayStr(){
    final DateTime date = new DateTime(DateTime.now().subtract(Duration(days:7)).year, DateTime.now().subtract(Duration(days:7)).month);
    final DateTime lastDay = DateUtils.lastDayOfMonth(date);
    var formatter = new DateFormat('dd');
    String formattedDate = formatter.format(lastDay);

    return formattedDate.toString();
  }

  /* 오늘날 기준 이번달 마지막날 문자열로 구하기 */
  String beforeMonthLastDay() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyyMMdd');

    now =now.add(new Duration(days: - int.parse(monthLastDayStr()) +1));
    String formattedDate = formatter.format(now);
    return formattedDate;
  }

  /* 오늘날 기준 전날에 7일 전을 문자열로 구하기 */
  String beforeDay() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyyMMdd');

    now =now.add(new Duration(days: -7));
    String formattedDate = formatter.format(now);
    return formattedDate;
  }

  /* 오늘날 기준 전날에 7일 전을 리스트로 구하기 */
  List<String> beforeDayList() {
    List<String> sevenDayList = [];
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyyMMdd');

    for(int i = 0; i < 7; i++){
      now =now.add(new Duration(days: -1));
      String formattedDate = formatter.format(now);
      sevenDayList.add(formattedDate);
    }
    return sevenDayList;
  }
}