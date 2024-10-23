// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

class AppTheme {
  static final light = ThemeData.light().copyWith(
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      elevation: 0,
    ),
    // Add more customizations here
  );

  static final dark = ThemeData.dark().copyWith(
    primaryColor: Colors.blueGrey,
    scaffoldBackgroundColor: Colors.grey[900],
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blueGrey,
      elevation: 0,
    ),
    // Add more customizations here
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
