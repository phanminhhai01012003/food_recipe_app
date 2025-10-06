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
    return Selector<ThemeState, ThemeMode>(
      selector: (context, state) => state.themeMode,
      shouldRebuild: (previous, next) => true,
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.green,
            foregroundColor: AppColors.white,
            title: Text("Thay đổi giao diện",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500
              ),
            ),
          ),
        );
      },
    );
  }
}