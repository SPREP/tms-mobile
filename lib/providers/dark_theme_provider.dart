import 'package:flutter/material.dart';
import 'package:macres/util/theme_preference.dart';

class ThemeProvider with ChangeNotifier {
  ThemePreference themePreference = ThemePreference();
  bool _darkTheme = false;
  bool isDarkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    isDarkTheme = value;
    themePreference.setDarkTheme(value);
    notifyListeners();
  }
}
