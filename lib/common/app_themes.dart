import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static ThemeData lightTheme = ThemeData(
    fontFamily: GoogleFonts.beVietnamPro().fontFamily,
    useMaterial3: true,
    brightness: Brightness.light,
  );
  static ThemeData darkTheme = ThemeData(
    fontFamily: GoogleFonts.beVietnamPro().fontFamily,
    useMaterial3: true,
    brightness: Brightness.dark
  );
}