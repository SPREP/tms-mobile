import 'package:flutter/material.dart';
import 'package:macres/models/weather_model.dart';

class TwentyFourHoursProvider extends ChangeNotifier {
  TwentyFourHoursForecastModel currentTwentyFourHoursData =
      TwentyFourHoursForecastModel();

  void setData(value) {
    currentTwentyFourHoursData = value;
    notifyListeners();
  }
}
