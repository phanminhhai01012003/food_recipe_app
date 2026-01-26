import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/configure/logger.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeLanguageState extends ChangeNotifier{
  String language_key = "language";
  bool _isEng = false;
  bool get isEng => _isEng;

  ChangeLanguageState(){
    loadData();
  }

  void loadData() async{
    try { 
      final pref = await SharedPreferences.getInstance();
      final langKey = pref.getBool(language_key) ?? false;
      _isEng = langKey;
    } catch (e) {
      Message.showToast("Đã xảy ra lỗi");
      Logger.log("Error: $e");
      rethrow;
    }
  }

  void saveData() async{
    try {
      final pref = await SharedPreferences.getInstance();
      await pref.setBool(language_key, _isEng);
    } catch (e) {
      Message.showToast("Đã xảy ra lỗi");
      Logger.log("Error: $e");
      rethrow;
    }
  }

  void setupLanguage(bool eng){
    if (_isEng != eng) {
      _isEng = eng;
      saveData();
      notifyListeners();
    }
  }

  void setEnglishLanguage() => setupLanguage(true);
  void setVietnameseLanguage() => setupLanguage(false);
}