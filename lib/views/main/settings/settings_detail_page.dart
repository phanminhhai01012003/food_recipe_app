import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/utils/routes.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/data/enum.dart';
import 'package:food_recipe_app/views/main/settings/selection.dart';
import 'package:food_recipe_app/widget/bottom_sheet/change_language_modal.dart';

class SettingsDetailPage extends StatefulWidget {
  const SettingsDetailPage({super.key});

  @override
  State<SettingsDetailPage> createState() => _SettingsDetailPageState();
}

class _SettingsDetailPageState extends State<SettingsDetailPage> {
  void onChooseMode(SettingsMode mode) async{
    switch(mode){
      case SettingsMode.about:
        Navigator.push(context, checkDeviceRoute(about));
        break;
      case SettingsMode.appServices:
        Navigator.push(context, checkDeviceRoute(service));
        break;
      case SettingsMode.theme:
        Navigator.push(context, checkDeviceRoute(changeThemeScreen));
        break;
      case SettingsMode.language:
        await changeLanguageModal(context);
        break;
    }
  }
  IconData getIcon(SettingsMode mode){
    switch (mode) {
      case SettingsMode.about:
        return Icons.info;
      case SettingsMode.appServices:
        return Icons.room_service;
      case SettingsMode.theme:
        return Icons.sunny;
      case SettingsMode.language:
        return Icons.language;
    }
  }
  String renderTitle(SettingsMode mode){
    switch (mode) {
      case SettingsMode.about:
        return "about".tr();
      case SettingsMode.appServices:
        return "appServices".tr();
      case SettingsMode.theme:
        return "theme".tr();
      case SettingsMode.language:
        return "lang".tr(); 
    }
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        centerTitle: true,
        title: Text("settings".tr(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800
          ),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
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
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Selection(
              onTap: () => onChooseMode(SettingsMode.about), 
              icon: getIcon(SettingsMode.about), 
              title: renderTitle(SettingsMode.about)
            ),
            Selection(
              onTap: () => onChooseMode(SettingsMode.appServices), 
              icon: getIcon(SettingsMode.appServices), 
              title: renderTitle(SettingsMode.appServices)
            ),
            Selection(
              onTap: () => onChooseMode(SettingsMode.theme),
              icon: getIcon(SettingsMode.theme),
              title: renderTitle(SettingsMode.theme),
            ),
            Selection(
              onTap: () => onChooseMode(SettingsMode.language),
              icon: getIcon(SettingsMode.language),
              title: renderTitle(SettingsMode.language),
            ),
          ],
        ),
      ),
    );
  }
}