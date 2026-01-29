import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/configure/logger.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeLanguageState extends ChangeNotifier{
  String language_key = "language";
  String _languageCode = "vi";
  String get languageCode => _languageCode;

  ChangeLanguageState(){
    loadData();
  }

  void loadData() async{
    try { 
      final pref = await SharedPreferences.getInstance();
      final langKey = pref.getString(language_key) ?? "";
      _languageCode = langKey;
    } catch (e) {
      Message.showToast("shortError".tr());
      Logger.log("Error: $e");
      rethrow;
    }
  }

  void saveData() async{
    try {
      final pref = await SharedPreferences.getInstance();
      await pref.setString(language_key, _languageCode);
    } catch (e) {
      Message.showToast("shortError".tr());
      Logger.log("Error: $e");
      rethrow;
    }
  }

  void setupLanguage(String langCode){
    if (_languageCode != langCode) {
      _languageCode = langCode;
      saveData();
      notifyListeners();
    }
  }

  void setEnglishLanguage() => setupLanguage("en");
  void setVietnameseLanguage() => setupLanguage("vi");
}