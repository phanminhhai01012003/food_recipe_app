import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/app_themes.dart';
import 'package:food_recipe_app/common/constants.dart';
import 'package:food_recipe_app/common/routes.dart';
import 'package:food_recipe_app/firebase/firebase_options.dart';
import 'package:food_recipe_app/provider/cookbook_state.dart';
import 'package:food_recipe_app/provider/history_state.dart';
import 'package:food_recipe_app/provider/save_state.dart';
import 'package:food_recipe_app/provider/theme_state.dart';
import 'package:food_recipe_app/services/notification/notification_service.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.initNotifications();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);
  // ignore: deprecated_member_use
  CloudinaryContext.cloudinary = Cloudinary.fromCloudName(cloudName: cloudName);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SaveState()),
        ChangeNotifierProvider(create: (_) => HistoryState()),
        ChangeNotifierProvider(create: (_) => CookbookState()),
        ChangeNotifierProvider(create: (_) => ThemeState())
      ],
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1)),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'PMH Food Recipe',
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: ThemeMode.system,
          home: LoaderOverlay(
            closeOnBackButton: false,
            overlayColor: Colors.transparent,
            overlayWidgetBuilder: (progress) => Center(
              child: CircularProgressIndicator(color: AppColors.yellow)
            ),
            switchInCurve: Easing.linear,
            switchOutCurve: Easing.linear,
            child: splashScreen
          )
        ),
      ),
    );
  }
}