import 'package:flutter/material.dart';
import 'package:macres/models/sun_model.dart';

class SunProvider extends ChangeNotifier {
  SunModel currentSunData = SunModel();

  void setData(value) {
    currentSunData = value;
    notifyListeners();
  }
}
