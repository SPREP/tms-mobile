import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: isDarkTheme ? Colors.black : Colors.white,
      primarySwatch: Colors.blueGrey,
      primaryColor: isDarkTheme ? Colors.black : Colors.white,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Colors.blueGrey,
        brightness: isDarkTheme ? Brightness.dark : Brightness.light,
        surface: isDarkTheme ? Color.fromARGB(255, 36, 37, 38) : Colors.white,
        onSurface: isDarkTheme ? Colors.white : Colors.black,
      ),
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
          : Theme.of(context).textTheme.apply(
              displayColor: Color.fromARGB(255, 29, 28, 28),
              bodyColor: const Color.fromARGB(255, 48, 48, 48)),
      highlightColor:
          isDarkTheme ? Color(0xff372901) : Color.fromARGB(255, 184, 183, 181),
      hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),
      focusColor: isDarkTheme
          ? Color.fromARGB(255, 10, 17, 38)
          : Color.fromARGB(255, 87, 117, 164),
      disabledColor: Colors.grey,
      cardColor: isDarkTheme ? Color(0xFF151515) : Colors.white,
      canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      appBarTheme: AppBarTheme(
        elevation: 0.0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey, foregroundColor: Colors.white),
      ),
      switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
          trackColor: MaterialStateProperty.resolveWith((states) =>
              states.contains(MaterialState.selected)
                  ? Theme.of(context).primaryColor
                  : null)),
    );
  }
}
