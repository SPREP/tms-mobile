import 'package:flutter/material.dart';

class WarningCounterProvider extends ChangeNotifier {
  int counter = 0;

  void setData(value) {
    counter = value;
    notifyListeners();
  }
}
