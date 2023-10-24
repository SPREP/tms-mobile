import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      primarySwatch: Colors.blueGrey,
      primaryColor: isDarkTheme ? Colors.black : Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDarkTheme
            ? Color.fromARGB(255, 77, 77, 78)
            : Color.fromARGB(255, 248, 247, 251),
      ),
      indicatorColor: isDarkTheme ? Color(0xff0E1D36) : Color(0xffCBDCF8),
      hintColor: isDarkTheme
          ? Color.fromARGB(255, 187, 186, 186)
          : Color.fromARGB(255, 137, 136, 136),
      textTheme: isDarkTheme
          ? Theme.of(context)
              .textTheme
              .apply(displayColor: Colors.white, bodyColor: Colors.white)
          : Theme.of(context)
              .textTheme
              .apply(displayColor: Colors.black, bodyColor: Colors.black),
      highlightColor: isDarkTheme ? Color(0xff372901) : Color(0xffFCE192),
      hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),
      focusColor: isDarkTheme
          ? Color.fromARGB(255, 10, 17, 38)
          : Color.fromARGB(255, 87, 117, 164),
      disabledColor: Colors.grey,
      cardColor: isDarkTheme ? Color(0xFF151515) : Colors.white,
      canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
            colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light(),
            buttonColor: Color.fromARGB(66, 118, 187, 216),
          ),
      appBarTheme: AppBarTheme(
        elevation: 0.0,
      ),
    );
  }
}
