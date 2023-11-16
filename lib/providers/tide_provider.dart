import 'package:flutter/material.dart';
import 'package:macres/models/tide_model.dart';

class TideProvider extends ChangeNotifier {
  TideModel currentTideData = TideModel(low: [], high: []);

  void setData(value) {
    currentTideData = value;
    notifyListeners();
  }
}
