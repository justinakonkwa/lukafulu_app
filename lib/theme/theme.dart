
import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background:  Colors.white,
    primary: Color(0xFF635BFF),
    secondary: Color(0xFFC4B6B6),
  ),
  appBarTheme: AppBarTheme(
    elevation: 0,
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Color(0xff191a1a),
    primary:Color(0xFF635BFF),
    secondary: Color(0xff61677A),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
  ),
);