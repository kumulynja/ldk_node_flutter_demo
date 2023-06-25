import 'package:flutter/material.dart';

class AppTheme {
  static const primaryBlue = Color.fromRGBO(14, 49, 246, 1); // LDK logo blue
  static const lightBlue = Color.fromRGBO(70, 120, 246, 1);
  static const darkBlue = Color.fromRGBO(10, 30, 150, 1);
  static const whiteColor = Colors.white;
  static const blackColor = Colors.black;
  static const lightGray = Color.fromRGBO(230, 230, 230, 1);
  static const errorRed = Colors.red;

  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryBlue,
    scaffoldBackgroundColor: whiteColor,
    textSelectionTheme: const TextSelectionThemeData(cursorColor: primaryBlue),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: primaryBlue, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryBlue, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: lightBlue, width: 2.0),
      ),
      labelStyle: TextStyle(color: primaryBlue),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: errorRed, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: errorRed, width: 2.0),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
          color: blackColor),
      displayMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
          color: blackColor),
      displaySmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.normal,
          fontFamily: 'Inter',
          color: blackColor),
      headlineMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          fontFamily: 'Inter',
          color: blackColor),
      headlineSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          fontFamily: 'Inter',
          color: blackColor),
      titleLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
          color: blackColor),
      titleMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          fontFamily: 'Inter',
          color: blackColor),
      titleSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.normal,
          fontFamily: 'Inter',
          color: blackColor),
      bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          fontFamily: 'Inter',
          color: blackColor),
      bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          fontFamily: 'Inter',
          color: blackColor),
      bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          fontFamily: 'Inter',
          color: blackColor),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: primaryBlue,
      textTheme: ButtonTextTheme.primary,
    ),
    colorScheme: const ColorScheme.light(
      primary: primaryBlue,
      secondary: lightBlue,
      error: errorRed,
      background: whiteColor,
      surface: lightGray,
    ).copyWith(secondary: lightBlue).copyWith(background: whiteColor),
  );
}
