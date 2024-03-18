import 'package:intl/intl.dart';

class SeaModel {
  String? level;
  String? temp;
  String? location;
  String? observedDate;

  SeaModel({this.level, this.temp, this.location, this.observedDate}) {}

  String getObservedTime() {
    if (observedDate == null) {
      return '';
    }

    DateFormat format = DateFormat('E, dd MMM yyyy HH:mm:ss Z');
    DateTime parsedDate = format.parse(observedDate!);

    DateFormat displayFormat = DateFormat('h:mm a');
    return displayFormat.format(parsedDate);
  }
}
