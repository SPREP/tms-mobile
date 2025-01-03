import 'package:intl/intl.dart';

class SunModel {
  String? id;
  String? rise;
  String? set;
  String? location;
  String? date;

  SunModel({this.id, this.location, this.date, this.rise, this.set}) {}

/**
 * Convert the given time to 24 hours
 */
  convertTo24(String time) {
    DateTime tempDate = DateFormat("hh:mm a").parse(time);
    var dateFormat = DateFormat("HH:mm");
    return double.parse(dateFormat.format(tempDate).replaceAll(':', '.'));
  }

/**
 * Check if Day or Night
 */
  bool isDay() {
    if (this.rise == null) return false;
    double hours = double.parse(
        DateFormat('HH:mm').format(DateTime.now()).replaceAll(':', '.'));

    double _riseTime = this.convertTo24(this.rise!);
    double _setTime = this.convertTo24(this.set!);
    bool _isday = (hours >= _riseTime && hours <= _setTime) ? true : false;

    return _isday;
  }

/**
 * Check if the given time is today
 */
  bool isToday() {
    final now = DateTime.now();

    DateTime date = DateTime.parse(this.date!);

    return now.year == date.year &&
        now.month == date.month &&
        now.day == date.day;
  }
}
