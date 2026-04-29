import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:food_recipe_app/common/constants/class_defined.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/common/style/app_themes.dart';
import 'package:food_recipe_app/common/utils/routes.dart';
import 'package:food_recipe_app/provider/theme_state.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    var localizedDelegated = LocalizedApp.of(context).delegate;
    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: Consumer<ThemeState>(
        builder: (context, value, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1)),
            child: GlobalLoaderOverlay(
              closeOnBackButton: false,
              overlayColor: Colors.white24,
              overlayWidgetBuilder: (progress) => Center(child: CircularProgressIndicator(color: AppColors.yellow)),
              switchInCurve: Easing.linear,
              switchOutCurve: Easing.linear,
              child: MaterialApp(
                localizationsDelegates: [
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  localizedDelegated
                ],
                supportedLocales: localizedDelegated.supportedLocales,
                locale: localizedDelegated.currentLocale,
                navigatorKey: navigatorKey,
                debugShowCheckedModeBanner: false,
                title: 'PMH Food Recipe',
                theme: AppThemes.lightTheme,
                darkTheme: AppThemes.darkTheme,
                themeMode: value.themeMode,
                home: splashScreen
              ),
            ),
          );
        },
      ),
    );
  }
}