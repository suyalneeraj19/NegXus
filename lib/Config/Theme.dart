import 'package:NegXus/Config/Colors.dart';
import 'package:flutter/material.dart';

var lightTheme = ThemeData();
var darkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  inputDecorationTheme: InputDecorationTheme(
    fillColor: dOnContainerColor,
    filled: true,
  ),
  colorScheme: ColorScheme.dark(
    primary: dPrimarColor,
    onPrimary: dBackgroundColor,
    background: dBackgroundColor,
    onBackground: dOnContainerColor,
    primaryContainer: dContainerColor,
    onPrimaryContainer: dOnContainerColor,
  ),
  textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        color: dPrimarColor,
        fontFamily: "Poppins",
        fontWeight: FontWeight.w800,
      ),
      headlineMedium: TextStyle(
        fontSize: 30,
        color: dOnBackgroundColor,
        fontFamily: "Poppins",
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        fontSize: 20,
        color: dPrimarColor,
        fontFamily: "Poppins",
        fontWeight: FontWeight.w600,
      ),
      labelLarge: TextStyle(
        fontSize: 15,
        color: dOnContainerColor,
        fontFamily: "Poppins",
        fontWeight: FontWeight.w400,
      ),
      bodyLarge: TextStyle(
        fontSize: 18,
        color: dOnBackgroundColor,
        fontFamily: "Poppins",
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(
        fontSize: 12,
        color: dOnContainerColor,
        fontFamily: "Poppins",
        fontWeight: FontWeight.w400,
      )),
);
