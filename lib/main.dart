import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:food_recipe_app/firebase/firebase_options.dart';
import 'package:food_recipe_app/my_app.dart';
import 'package:food_recipe_app/provider/change_language_state.dart';
import 'package:food_recipe_app/provider/cookbook_state.dart';
import 'package:food_recipe_app/provider/history_state.dart';
import 'package:food_recipe_app/provider/save_state.dart';
import 'package:food_recipe_app/provider/theme_state.dart';
import 'package:food_recipe_app/services/notification/notification_service.dart';
import 'package:provider/provider.dart';

void main() async{
  var delegate = await LocalizationDelegate.create(
    fallbackLocale: "vi", 
    supportedLocales: ["vi", "en"],
    basePath: "assets/language/"
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.initNotifications();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    LocalizedApp(
      delegate,
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SaveState()),
          ChangeNotifierProvider(create: (_) => HistoryState()),
          ChangeNotifierProvider(create: (_) => CookbookState()),
          ChangeNotifierProvider(create: (_) => ThemeState()),
          ChangeNotifierProvider(create: (_) => ChangeLanguageState())
        ],
        child: MyApp()
      ),
    )
  );
}