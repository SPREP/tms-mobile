import 'package:intl/intl.dart';

class SunModel {
  String? id;
  String? rise;
  String? set;
  String? location;
  String? date;

  SunModel({this.id, this.location, this.date, this.rise, this.set}) {}

  convertTo24(String time) {
    DateTime tempDate = DateFormat("hh:mm a").parse(time);
    var dateFormat = DateFormat("HH:mm");
    return double.parse(dateFormat.format(tempDate).replaceAll(':', '.'));
  }
}
