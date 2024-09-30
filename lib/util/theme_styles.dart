import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    Color mainColor = Color.fromARGB(255, 32, 46, 90);
    var kColorScheme = ColorScheme.fromSeed(seedColor: mainColor);
    return ThemeData().copyWith(
      canvasColor: isDarkTheme ? mainColor : Colors.white,
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
      textTheme: ThemeData()
          .textTheme
          .copyWith(
            bodyMedium: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.5),
            bodyLarge: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
            titleSmall: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
            displayLarge: GoogleFonts.roboto(
              fontSize: 97,
              fontWeight: FontWeight.w300,
              letterSpacing: -1.5,
            ),
            displayMedium: GoogleFonts.roboto(
                fontSize: 61, fontWeight: FontWeight.w300, letterSpacing: -0.5),
            displaySmall:
                GoogleFonts.roboto(fontSize: 48, fontWeight: FontWeight.w400),
            headlineMedium: GoogleFonts.roboto(
                fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
            headlineSmall:
                GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.w400),
            titleLarge: GoogleFonts.roboto(
                fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
            titleMedium: GoogleFonts.roboto(
                fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
            labelLarge: GoogleFonts.roboto(
                fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
            bodySmall: GoogleFonts.roboto(
                fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.3),
            labelSmall: GoogleFonts.roboto(
                fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
          )
          .apply(
            //fontFamily: GoogleFonts.openSans().fontFamily,
            fontFamily: GoogleFonts.roboto().fontFamily,
            bodyColor: isDarkTheme ? Colors.white : Colors.black,
            displayColor: isDarkTheme ? Colors.white : Colors.black,
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
          foregroundColor: isDarkTheme
              ? const Color.fromARGB(255, 108, 108, 108)
              : mainColor,
        ),
      ),
      chipTheme: ChipThemeData().copyWith(
        backgroundColor:
            isDarkTheme ? const Color.fromARGB(255, 94, 94, 94) : Colors.white,
        padding: EdgeInsets.all(2.0),
        labelPadding: EdgeInsets.only(left: 1.0, right: 5.0),
        labelStyle: TextStyle(color: isDarkTheme ? Colors.white : mainColor),
        side: BorderSide(color: isDarkTheme ? Colors.white : mainColor),
        iconTheme: IconThemeData().copyWith(
            color: isDarkTheme
                ? Colors.white
                : const Color.fromARGB(255, 92, 92, 92)),
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
