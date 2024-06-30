import 'package:flutter/material.dart';

ThemeData theme() {
  return ThemeData(
      primaryColor: const Color.fromRGBO(187, 37, 74, 1),
      scaffoldBackgroundColor: Colors.white,
      fontFamily: 'Modernist',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: 28,
        ),
        displayMedium: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.normal,
          fontSize: 16,
        ),
        displaySmall: TextStyle(
          color: Color.fromRGBO(113, 113, 113, 1),
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ));
}
