import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/provider/theme_state.dart';
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
                      InkWell(
                        onTap: value.systemTheme,
                        child: Column(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: value.isSystem ? AppColors.green : theme.colorScheme.primary
                              ),
                              child: Icon(
                                Icons.auto_mode,
                                size: 20,
                                color: value.isSystem ? AppColors.white : theme.colorScheme.secondary,
                              )
                            ),
                            SizedBox(height: 5),
                            Text("Hệ thống",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal
                              ),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: value.lightTheme,
                        child: Column(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: value.isLight ? AppColors.green : theme.colorScheme.primary
                              ),
                              child: Icon(
                                Icons.sunny, 
                                size: 20,
                                color: value.isLight ? AppColors.white : theme.colorScheme.secondary,
                              )
                            ),
                            SizedBox(height: 5),
                            Text("Sáng",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal
                              ),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: value.darkTheme,
                        child: Column(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: value.isDark ? AppColors.green : theme.colorScheme.primary
                              ),
                              child: Icon(
                                Icons.dark_mode,
                                size: 20,
                                color: value.isDark ? AppColors.white : theme.colorScheme.secondary,
                              )
                            ),
                            SizedBox(height: 5),
                            Text("Tối",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal
                              ),
                            )
                          ],
                        ),
                      )
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