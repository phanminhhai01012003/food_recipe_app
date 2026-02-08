import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/configure/logger.dart';
import 'package:food_recipe_app/common/constants/class_defined.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/widget/other/message.dart';

class ThemeState extends ChangeNotifier{
  String key = "theme_mode";
  ThemeMode theme = ThemeMode.system;
  ThemeMode get themeMode => theme;

  bool get isLight => theme == ThemeMode.light;
  bool get isDark => theme == ThemeMode.dark;
  bool get isSystem => theme == ThemeMode.system;

  ThemeState(){
    loadData();
  }
  
  void loadData() async{
    try {
      final themeIndex = await spServices.getIntValue(key) ?? 0;
      theme = ThemeMode.values[themeIndex];
      notifyListeners();
    } catch (e) {
      Message.showToast("shortError".tr());
      Logger.log("Error: $e");
      rethrow;
    }
  }

  void saveData() async{
    try {
      await spServices.setIntValue(key, theme.index);
    } catch (e) {
      Message.showToast("shortError".tr());
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

  void lightTheme() => setupTheme(ThemeMode.light);
  void darkTheme() => setupTheme(ThemeMode.dark);
  void systemTheme() => setupTheme(ThemeMode.system);
}