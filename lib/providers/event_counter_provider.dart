import 'package:flutter/material.dart';

class EventCounterProvider extends ChangeNotifier {
  int counter = 0;

  void setData(value) {
    counter = value;
    notifyListeners();
  }
}
