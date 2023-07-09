import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale selectedLocale = const Locale('en');

  void setLocale(value) {
    selectedLocale = Locale(value);
    notifyListeners();
  }
}
