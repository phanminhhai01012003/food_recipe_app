import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static ThemeData lightTheme = ThemeData(
    fontFamily: GoogleFonts.beVietnamPro().fontFamily,
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: AppColors.white,
      secondary: AppColors.black
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.green,
      foregroundColor: AppColors.white
    ),
  );
  static ThemeData darkTheme = ThemeData(
    fontFamily: GoogleFonts.beVietnamPro().fontFamily,
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.black,
      secondary: AppColors.white
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.green,
      foregroundColor: AppColors.white
    )
  );
}