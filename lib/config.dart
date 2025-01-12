import 'package:flutter/material.dart';

class ServerAPI {
  // static const String apiBaseUrl = 'http://localhost:5000'; // localhost
  // static const String apiBaseUrl = 'http://51.84.9.120'; // my server
  // static const String apiBaseUrl = 'http://51.16.37.75'; // student-7
  static const String baseUrl =
      'https://student-7.boukingolts.art'; // student-7
  // static const int color_promary = #19276F;
}

class AppTheme {
  // Define primary and secondary colors
  static const Color primaryColor = Color(0xFF19276F); // Purple
  static const Color secondaryColor = Color(0xFF39A7EE); // Teal
  static const Color backgroundColor = Color(0xFFF8F8F8); // White
  static const Color cardColor = Color(0xFFFFFFFF); // White

  // Define text styles
  static const TextStyle h1 = TextStyle(
    color: primaryColor,
    fontSize: 56,
    fontFamily: 'Assistant',
    fontWeight: FontWeight.w700,
    // height: 0.04,
  );

  // Define text styles
  static const TextStyle h2 = TextStyle(
    color: primaryColor,
    fontSize: 32,
    fontFamily: 'Assistant',
    fontWeight: FontWeight.w700,
    // height: 0.04,
  );

  // Define text styles
  static const TextStyle h3 = TextStyle(
    color: primaryColor,
    fontSize: 24,
    fontFamily: 'Assistant',
    fontWeight: FontWeight.w700,
    // height: 0.04,
  );

  static const TextStyle label = TextStyle(
    color: primaryColor,
    fontSize: 16,
    fontFamily: 'Assistant',
    fontWeight: FontWeight.w700,
    // height: 0.09,
  );

  static const TextStyle p = TextStyle(
    color: primaryColor,
    fontSize: 16,
    fontFamily: 'Assistant',
    fontWeight: FontWeight.w400,
    // height: 0,
  );

  static const TextStyle item = TextStyle(
    color: secondaryColor,
    fontSize: 16,
    fontFamily: 'Assistant',
    fontWeight: FontWeight.w400,
    // height: 0.09,
  );

  static const BoxShadow primaryShadow = BoxShadow(
    color: Color(0x1919276F),
    blurRadius: 10,
    offset: Offset(0, 4),
    spreadRadius: 0,
  );

  static const BoxShadow secondaryShadow = BoxShadow(
    color: Color(0x26000000),
    blurRadius: 8,
    offset: Offset(0, 4),
    spreadRadius: 0,
  );

  // Define padding and spacing constants
  static const double itemPadding = 16.0;
    // Define padding and spacing constants
  static const double sectionPadding = 40.0;

  // Define the overall theme
  static ThemeData get appBarTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: 'Assistant', // Change to your preferred font
      textTheme: const TextTheme(
        displayLarge: h1,
        bodyLarge: label,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: primaryColor,
        elevation: 1,
        toolbarHeight: 85,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
            ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: secondaryColor,
          textStyle: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  // Define the overall theme
  static ThemeData get themeData {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: 'Assistant', // Change to your preferred font
      textTheme: const TextTheme(
        displayLarge: h1,
        bodyLarge: label,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: cardColor,
        foregroundColor: primaryColor,
        elevation: 1,
        toolbarHeight: 85
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: secondaryColor,
          textStyle: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
