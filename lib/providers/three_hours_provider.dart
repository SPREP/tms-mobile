import 'package:flutter/material.dart';
import 'package:macres/models/weather_model.dart';

class ThreeHoursProvider extends ChangeNotifier {
  ThreeHoursForecastModel currentThreeHoursData = ThreeHoursForecastModel();

  void setData(value) {
    currentThreeHoursData = value;
    notifyListeners();
  }
}
