import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeState extends ChangeNotifier{
  String key = "theme_mode";
  ThemeMode theme = ThemeMode.system;
  ThemeMode get themeMode => theme;
  
  bool get isLight => theme == ThemeMode.light;
  bool get isDark => theme == ThemeMode.dark;
  bool get isSystem => theme == ThemeMode.system;
  
  void loadData() async{
    try {
      final pref = await SharedPreferences.getInstance();
      final themeIndex = pref.getInt(key) ?? 0;
      theme = ThemeMode.values[themeIndex];
      notifyListeners();
    } catch (e) {
      Logger.log("Error: $e");
      rethrow;
    }
  }

  void saveData() async{
    try {
      final pref = await SharedPreferences.getInstance();
      await pref.setInt(key, theme.index);
    } catch (e) {
      Logger.log("Error: $e");
      rethrow;
    }
  }

  void setupTheme(ThemeMode mode){
    if (theme != mode){
      theme = mode;
      saveData();
      notifyListeners();
    }
  }

  void toggleTheme(){
    if (theme == ThemeMode.light) {
      theme = ThemeMode.dark;
    } else {
      theme = ThemeMode.light;
    }
  }

  void lightTheme() => setupTheme(ThemeMode.light);
  void darkTheme() => setupTheme(ThemeMode.dark);
  void systemTheme() => setupTheme(ThemeMode.system);
}