import 'package:flutter_translate/flutter_translate.dart';

Future<LocalizationDelegate> setupLanguage() async{
  return await LocalizationDelegate.create(
    fallbackLocale: "en", 
    supportedLocales: ["en", "vi"],
    basePath: "assets/language/"
  );
}