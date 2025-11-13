import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_recipe_app/provider/theme_state.dart';
import 'package:food_recipe_app/views/main/sub_features/theme/change_theme_button.dart';
import 'package:provider/provider.dart';

class ChangeThemeScreen extends StatefulWidget {
  const ChangeThemeScreen({super.key});

  @override
  State<ChangeThemeScreen> createState() => _ChangeThemeScreenState();
}

class _ChangeThemeScreenState extends State<ChangeThemeScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<ThemeState>(
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: theme.colorScheme.primary,
          appBar: AppBar(
            leading: Padding(
              padding: EdgeInsets.all(8),
              child: IconButton(
                onPressed: () => Navigator.pop(context), 
                  icon: Icon(
                    Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
                    size: 20,
                  )
                ),
            ),
            backgroundColor: theme.appBarTheme.backgroundColor,
            foregroundColor: theme.appBarTheme.foregroundColor,
            title: Text("Chế độ giao diện",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500
              ),
            ),
            centerTitle: true,
          ),
          body: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Card(
                surfaceTintColor: theme.colorScheme.primary,
                child: Container(
                  padding: EdgeInsets.all(12),
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: theme.colorScheme.primary
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ChangeThemeButton(
                        onTap: value.systemTheme, 
                        screenState: value.isSystem, 
                        themeIcon: Icons.auto_mode, 
                        text: "Hệ thống"
                      ),
                      ChangeThemeButton(
                        onTap: value.lightTheme, 
                        screenState: value.isLight, 
                        themeIcon: Icons.light_mode, 
                        text: "Sáng"
                      ),
                      ChangeThemeButton(
                        onTap: value.darkTheme, 
                        screenState: value.isDark, 
                        themeIcon: Icons.dark_mode, 
                        text: "Tối"
                      ),
                    ],
                  ),
                )
              ),
            ),
          )
        );
      },
    );
  }
}