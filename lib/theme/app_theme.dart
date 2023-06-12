import 'package:flutter/material.dart';

class AppTheme {
  // Kumuly colors
  static const orange = Color.fromRGBO(255, 139, 41, 1);
  static const portlandOrange = Color.fromRGBO(255, 88, 54, 1);
  static const russianViolet = Color.fromRGBO(36, 6, 57, 1);
  static const blueViolet = Color.fromRGBO(74, 17, 107, 1);
  static const mediumSlateBlue = Color.fromRGBO(130, 96, 237, 1);
  static const peachPuff = Color.fromRGBO(255, 247, 240, 1);
  static const peachPuff50 = Color.fromRGBO(255, 241, 230, 1);
  static const peachPuff30 = Color.fromRGBO(255, 223, 194, 1);
  static const gray4 = Color.fromRGBO(249, 249, 255, 1);
  static const gray3 = Color.fromRGBO(242, 242, 252, 1);
  static const gray2 = Color.fromRGBO(226, 231, 244, 1);
  static const gray1 = Color.fromRGBO(208, 211, 219, 1);
  static const darkGray4 = Color.fromRGBO(162, 168, 184, 1);
  static const darkGray3 = Color.fromRGBO(112, 122, 148, 1);
  static const darkGray2 = Color.fromRGBO(79, 85, 102, 1);
  static const darkGray1 = Color.fromRGBO(41, 44, 54, 1);

  static final ThemeData lightTheme = ThemeData.from(
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: orange,
        onPrimary: Colors.white,
        secondary: portlandOrange,
        onSecondary: Colors.white,
        error: Colors.red,
        onError: Colors.white,
        background: Colors.white,
        onBackground: russianViolet,
        surface: orange,
        onSurface: Colors.white,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
          color: darkGray1,
        ),
        displayMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
          color: darkGray1,
        ),
        displaySmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
          color: darkGray1,
        ),
        headlineLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
          color: darkGray1,
        ),
        headlineMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
          color: darkGray1,
        ),
        headlineSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
          color: darkGray1,
        ),
        titleLarge: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
          color: darkGray1,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          fontFamily: 'Inter',
          color: darkGray1,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          fontFamily: 'Inter',
          color: darkGray1,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          fontFamily: 'Inter',
          color: darkGray1,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          fontFamily: 'Inter',
          color: darkGray1,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          fontFamily: 'Inter',
          color: darkGray1,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
          color: darkGray1,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          fontFamily: 'Inter',
          color: darkGray1,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.normal,
          fontFamily: 'Inter',
          color: darkGray1,
        ),
      ));
}
