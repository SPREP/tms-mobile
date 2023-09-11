import 'package:flutter/material.dart';
import 'package:macres/models/weather_model.dart';

class TenDaysProvider extends ChangeNotifier {
  List<TenDaysForecastModel> currentTenDaysData = [];

  void setData(value) {
    currentTenDaysData = value;
    notifyListeners();
  }
}
