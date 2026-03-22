import 'package:flutter_translate/flutter_translate.dart';

Future<LocalizationDelegate> setupLanguage() async{
  return await LocalizationDelegate.create(
    fallbackLocale: "vi", 
    supportedLocales: ["vi", "en"],
    basePath: "assets/language/"
  );
}