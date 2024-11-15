
import 'package:flutter/material.dart';

class AppTheme {
  static final light = ThemeData.light().copyWith(
    primaryColor: CIETTheme.primary_color,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: CIETTheme.primary_color,
      elevation: 0,
    ),
  );

  static final dark = ThemeData.dark().copyWith(
    primaryColor: Colors.blue.shade900,
    scaffoldBackgroundColor: Colors.grey[900],
    appBarTheme: const AppBarTheme(
      backgroundColor: CIETTheme.primary_color,
      elevation: 0,
    ),
  );
}

class CIETTheme {
  static const Color primary_color = Color(0xFF22BDFF);
  static const Color secondary_color = Color(0xFF00618A);
  static const Color bg_color = Color(0xFFEFEFEF);
  static const double font_size = 18;
  static const int element_spacing = 15;
  static const double rounded_corner = 10;
  static const double button_rounded_corner = 30;
  static const Color border_color = Color(0xFFCECECE);
  static const String font_family = "Poppins";
}
