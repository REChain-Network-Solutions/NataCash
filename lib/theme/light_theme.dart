import 'package:flutter/material.dart';
import 'package:six_cash/util/color_resources.dart';
ThemeData light = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'Rubik',
  primaryColor: const Color(0xFF003E47),
  secondaryHeaderColor: const Color(0xFFE0EC53),
  highlightColor: const Color(0xFF003E47),
  cardColor: Colors.white,
  shadowColor: Colors.grey[300],
  textTheme: const TextTheme(
    titleLarge: TextStyle(color: Color(0xFF003E47)),
    titleSmall: TextStyle(color: Color(0xFF25282D)),
  ),
  dialogTheme: const DialogTheme(surfaceTintColor: Colors.white),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white, selectedItemColor: ColorResources.themeLightBackgroundColor,
  ),
  colorScheme: ColorScheme(
    // background: const Color(0xFFf0f0f0),
    background: const Color(0xFFfaf7f6),
    brightness: Brightness.light,
    primary: const Color(0xFF003E47),
    onPrimary: const Color(0xFF562E9C),
    secondary: const Color(0xFFE0EC53),
    onSecondary: const Color(0xFFE0EC53),
    error: Colors.redAccent,
    onError: Colors.redAccent,
    onBackground: const Color(0xFFC3CAD9),
    surface: Colors.white,
    onSurface:  const Color(0xFF002349),
    shadow: Colors.grey[300],
  ),

);