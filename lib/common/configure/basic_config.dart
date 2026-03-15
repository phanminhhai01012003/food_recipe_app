import 'package:flutter_translate/flutter_translate.dart';

class BasicConfig {
  static Future<LocalizationDelegate> setupLanguage() async{
    return await LocalizationDelegate.create(
      fallbackLocale: "vi", 
      supportedLocales: ["vi", "en"],
      basePath: "assets/language/"
    );
  }
}