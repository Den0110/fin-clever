import 'package:intl/intl.dart';

extension MyDateUtils on DateTime {
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }

  String formatDate() {
    final DateFormat formatter = DateFormat.yMMMMd();
    return formatter.format(this);
  }
  String formatMY() {
    final DateFormat formatter = DateFormat.yMMM();
    return formatter.format(this);
  }
  String formatDM() {
    final DateFormat formatter = DateFormat("dd.MM");
    return formatter.format(this);
  }

  static String getGreetingByTime() {
    final hour = DateTime.now().hour;
    if(4 <= hour && hour <= 11) {
      return 'Доброе утро';
    } else if(12 <= hour && hour <= 17){
      return 'Добрый день';
    } else if(18 <= hour && hour <= 23){
      return 'Добрый вечер';
    } else {
      return 'Доброй ночи';
    }
  }

  static DateTime dateFromJson(int int) =>
      DateTime.fromMillisecondsSinceEpoch(int*1000);

  static int dateToJson(DateTime time) => time.millisecondsSinceEpoch~/1000;
}