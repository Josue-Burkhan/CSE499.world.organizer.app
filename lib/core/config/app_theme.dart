import 'package:flutter/material.dart';

class AppTheme {
  static const Color _primaryColor = Color(0xFF018F8F);
  static Color get turquoiseColor => _primaryColor;

  static final ThemeData lightTheme = ThemeData.from(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryColor,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
  );

  static final ThemeData darkTheme = ThemeData.from(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryColor,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  );
}
