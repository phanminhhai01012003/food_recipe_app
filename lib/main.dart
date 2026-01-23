import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_recipe_app/firebase/firebase_options.dart';
import 'package:food_recipe_app/my_app.dart';
import 'package:food_recipe_app/provider/cookbook_state.dart';
import 'package:food_recipe_app/provider/history_state.dart';
import 'package:food_recipe_app/provider/save_state.dart';
import 'package:food_recipe_app/provider/theme_state.dart';
import 'package:food_recipe_app/services/notification/notification_service.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.initNotifications();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SaveState()),
        ChangeNotifierProvider(create: (_) => HistoryState()),
        ChangeNotifierProvider(create: (_) => CookbookState()),
        ChangeNotifierProvider(create: (_) => ThemeState())
      ],
      child: MyApp()
    )
  );
}