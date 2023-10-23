import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      primarySwatch: Colors.blueGrey,
      primaryColor: isDarkTheme ? Colors.black : Colors.white,

      // colorScheme.copyWith(): isDarkTheme ? Colors.black : Color(0xffF1F5FB),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDarkTheme
            ? Color.fromARGB(255, 77, 77, 78)
            : Color.fromARGB(255, 238, 235, 246),
      ),

      indicatorColor: isDarkTheme ? Color(0xff0E1D36) : Color(0xffCBDCF8),
      //buttonColor: isDarkTheme ? Color(0xff3B3B3B) : Color(0xffF1F5FB),
      hintColor: isDarkTheme ? Color(0xff280C0B) : Color(0xffEECED3),
      textTheme: isDarkTheme
          ? Theme.of(context)
              .textTheme
              .apply(displayColor: Colors.white, bodyColor: Colors.white)
          : Theme.of(context)
              .textTheme
              .apply(displayColor: Colors.black, bodyColor: Colors.black),
      highlightColor: isDarkTheme ? Color(0xff372901) : Color(0xffFCE192),
      hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),

      focusColor: isDarkTheme ? Color(0xff0B2512) : Color(0xffA8DAB5),
      disabledColor: Colors.grey,
      //textSelectionColor: isDarkTheme ? Colors.white : Colors.black,
      cardColor: isDarkTheme ? Color(0xFF151515) : Colors.white,
      canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
      appBarTheme: AppBarTheme(
        elevation: 0.0,
      ),
    );
  }
}
