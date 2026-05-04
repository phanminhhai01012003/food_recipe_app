import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:food_recipe_app/common/utils/basic_config.dart';
import 'package:food_recipe_app/common/constants/list_constants.dart';
import 'package:food_recipe_app/firebase/firebase_options.dart';
import 'package:food_recipe_app/my_app.dart';
import 'package:food_recipe_app/provider/change_language_state.dart';
import 'package:food_recipe_app/provider/cookbook_state.dart';
import 'package:food_recipe_app/provider/fridge_state.dart';
import 'package:food_recipe_app/provider/history_state.dart';
import 'package:food_recipe_app/provider/save_state.dart';
import 'package:food_recipe_app/provider/theme_state.dart';
import 'package:food_recipe_app/services/notification/notification_service.dart';
import 'package:provider/provider.dart';

void main() async{
  await dotenv.load(fileName: ".env");
  var delegate = await setupLanguage();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.initNotifications();
  SystemChrome.setPreferredOrientations(orientations);
  runApp(
    LocalizedApp(
      delegate,
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SaveState()),
          ChangeNotifierProvider(create: (context) => HistoryState()),
          ChangeNotifierProvider(create: (context) => CookbookState()),
          ChangeNotifierProvider(create: (context) => ThemeState()),
          ChangeNotifierProvider(create: (context) => ChangeLanguageState()),
          ChangeNotifierProvider(create: (context) => FridgeState())
        ],
        child: MyApp()
      ),
    )
  );
}