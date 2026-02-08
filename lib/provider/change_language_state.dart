import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:food_recipe_app/common/configure/logger.dart';
import 'package:food_recipe_app/common/constants/class_defined.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/widget/other/message.dart';

class ChangeLanguageState extends ChangeNotifier{
  String language_key = "language";
  String _languageCode = localeToString(Locale("vi"));
  String get languageCode => _languageCode;

  bool get isVietnamese => languageCode == localeToString(Locale("vi"));
  bool get isEnglish => languageCode == localeToString(Locale("en"));

  ChangeLanguageState(){
    loadData();
  }

  void loadData() async{
    try { 
      final langKey = await spServices.getStringValue(language_key) ?? "";
      _languageCode = langKey;
    } catch (e) {
      Message.showToast("shortError".tr());
      Logger.log("Error: $e");
      rethrow;
    }
  }

  void saveData() async{
    try {
      await spServices.setStringValue(language_key, _languageCode);
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

  void setEnglishLanguage() => setupLanguage(localeToString(Locale("en")));
  void setVietnameseLanguage() => setupLanguage(localeToString(Locale("vi")));
}