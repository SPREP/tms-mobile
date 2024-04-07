import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    Color mainColor = Color.fromARGB(255, 32, 46, 90);
    var kColorScheme = ColorScheme.fromSeed(seedColor: mainColor);
    return ThemeData().copyWith(
      canvasColor: isDarkTheme ? Colors.black : Colors.white,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      hintColor: isDarkTheme ? Colors.white : Colors.black,
      colorScheme: kColorScheme,
      appBarTheme: AppBarTheme().copyWith(
        backgroundColor: isDarkTheme ? Colors.black : mainColor,
        foregroundColor: Colors.white,
        centerTitle: false,
      ),
      scaffoldBackgroundColor:
          isDarkTheme ? const Color.fromARGB(255, 39, 39, 39) : Colors.white,
      textTheme: ThemeData().textTheme.copyWith(
            bodyMedium: isDarkTheme
                ? TextStyle(color: Colors.white)
                : TextStyle(color: Colors.black),
            bodyLarge: isDarkTheme
                ? TextStyle(color: Colors.white)
                : TextStyle(color: Colors.black),
            titleSmall: isDarkTheme
                ? TextStyle(color: Colors.white)
                : TextStyle(color: Colors.black),
          ),
      iconTheme: isDarkTheme
          ? IconThemeData(color: Colors.white)
          : IconThemeData(color: Colors.black),
      bottomNavigationBarTheme: BottomNavigationBarThemeData().copyWith(
        selectedItemColor: isDarkTheme ? Colors.white : mainColor,
        backgroundColor:
            isDarkTheme ? Color.fromARGB(255, 58, 58, 58) : Colors.white,
        selectedIconTheme: isDarkTheme
            ? IconThemeData(color: Colors.white)
            : IconThemeData(color: mainColor),
        unselectedIconTheme: isDarkTheme
            ? IconThemeData(color: const Color.fromARGB(255, 188, 188, 188))
            : IconThemeData(color: const Color.fromARGB(255, 136, 136, 136)),
        unselectedItemColor:
            isDarkTheme ? Color.fromARGB(255, 188, 188, 188) : Colors.black,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: mainColor, foregroundColor: Colors.white),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: isDarkTheme ? Colors.white : mainColor,
        ),
      ),
      chipTheme: ChipThemeData().copyWith(
        backgroundColor: Colors.white,
        padding: EdgeInsets.all(2.0),
        labelPadding: EdgeInsets.only(left: 1.0, right: 5.0),
        side: BorderSide(color: isDarkTheme ? Colors.white : mainColor),
      ),
      dropdownMenuTheme: DropdownMenuThemeData().copyWith(
        inputDecorationTheme: InputDecorationTheme(
          labelStyle:
              TextStyle(color: isDarkTheme ? Colors.white : Colors.black),
        ),
      ),
      checkboxTheme: CheckboxThemeData().copyWith(
        side: isDarkTheme ? BorderSide(color: Colors.white) : BorderSide(),
      ),
      listTileTheme: ListTileThemeData().copyWith(
        textColor: isDarkTheme ? Colors.white : Colors.black,
        iconColor: isDarkTheme
            ? Colors.white
            : const Color.fromARGB(255, 130, 129, 129),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(
          color: isDarkTheme ? Colors.white : Colors.black,
        ),
      ),
      drawerTheme: DrawerThemeData().copyWith(
        backgroundColor:
            isDarkTheme ? const Color.fromARGB(255, 78, 77, 77) : Colors.white,
      ),
      cardTheme: CardTheme().copyWith(
        color: isDarkTheme ? Colors.black : Colors.white,
      ),
      dialogTheme: DialogTheme().copyWith(
        backgroundColor:
            isDarkTheme ? Color.fromARGB(255, 95, 95, 95) : Colors.white,
        titleTextStyle: TextStyle(
            color: isDarkTheme ? Colors.white : Colors.black,
            fontSize: 17.0,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
