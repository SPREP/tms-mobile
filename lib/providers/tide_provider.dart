import 'package:flutter/material.dart';
import 'package:macres/models/tide_model.dart';

class TideProvider extends ChangeNotifier {
  TideModel currentTideData = TideModel();

  void setData(value) {
    currentTideData = value;
    notifyListeners();
  }
}
