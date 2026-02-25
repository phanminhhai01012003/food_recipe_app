import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/constants/class_defined.dart';
import 'package:food_recipe_app/common/constants/firebase_constants.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';

import 'package:food_recipe_app/common/configure/routes.dart';
import 'package:food_recipe_app/data/enum.dart';
import 'package:food_recipe_app/model/user_model.dart';
import 'package:food_recipe_app/views/main/settings/selection.dart';
import 'package:food_recipe_app/views/main/settings/user_widget.dart';
import 'package:food_recipe_app/widget/bottom_sheet/change_language_modal.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void onChooseMode(ModeSelection mode) async{
    switch(mode){
      case ModeSelection.about:
        Navigator.push(context, checkDeviceRoute(about));
        break;
      case ModeSelection.appServices:
        Navigator.push(context, checkDeviceRoute(service));
        break;
      case ModeSelection.report:
        Navigator.push(context, checkDeviceRoute(reportPage));
        break;
      case ModeSelection.changePassword:
        Navigator.push(context, checkDeviceRoute(changePasswordPage));
        break;
      case ModeSelection.theme:
        Navigator.push(context, checkDeviceRoute(changeThemeScreen));
        break;
      case ModeSelection.rating:
        Navigator.push(context, checkDeviceRoute(fullRatingPage));
        break;
      case ModeSelection.language:
        await changeLanguageModal(context);
        break;
    }
  }
  IconData getIcon(ModeSelection mode){
    switch (mode) {
      case ModeSelection.about:
        return Icons.info;
      case ModeSelection.appServices:
        return Icons.room_service;
      case ModeSelection.report:
        return Icons.report;
      case ModeSelection.changePassword:
        return Icons.lock;
      case ModeSelection.theme:
        return Icons.sunny;
      case ModeSelection.rating:
        return Icons.star;
      case ModeSelection.language:
        return Icons.language;
    }
  }
  String renderTitle(ModeSelection mode){
    switch (mode) {
      case ModeSelection.about:
        return "about".tr();
      case ModeSelection.appServices:
        return "appServices".tr();
      case ModeSelection.report:
        return "reportList".tr();
      case ModeSelection.changePassword:
        return "changePassword".tr();
      case ModeSelection.theme:
        return "theme".tr();
      case ModeSelection.rating:
        return "rate".tr();
      case ModeSelection.language:
        return "lang".tr(); 
    }
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: Padding(
        padding: EdgeInsets.only(top: 30, left: 12, right: 12, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: userServices.getUserById(context, currentUser.uid), 
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.hasError) {
                  return Icon(Icons.error, size: 100, color: AppColors.red);
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: AppColors.yellow));
                } else {
                  List<UserModel> userList = snapshot.data!;
                  return ListView.builder(
                    itemCount: userList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => UserWidget(
                      user: userList[index], 
                      onTap: () => Navigator.push(context, checkDeviceRoute(userInform(userList[index])))
                    ),
                  );
                }
              }
            ),
            SizedBox(height: 30),
            Divider(height: 1, thickness: 1, color: AppColors.grey),
            ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: [
                Selection(
                  onTap: () => onChooseMode(ModeSelection.about), 
                  icon: getIcon(ModeSelection.about), 
                  title: renderTitle(ModeSelection.about)
                ),
                Selection(
                  onTap: () => onChooseMode(ModeSelection.appServices), 
                  icon: getIcon(ModeSelection.appServices), 
                  title: renderTitle(ModeSelection.appServices)
                ),
                Selection(
                  onTap: () => onChooseMode(ModeSelection.report), 
                  icon: getIcon(ModeSelection.report), 
                  title: renderTitle(ModeSelection.report)
                ),
                Selection(
                  onTap: () => onChooseMode(ModeSelection.changePassword), 
                  icon: getIcon(ModeSelection.changePassword), 
                  title: renderTitle(ModeSelection.changePassword)
                ),
                Selection(
                  onTap: () => onChooseMode(ModeSelection.theme),
                  icon: getIcon(ModeSelection.theme),
                  title: renderTitle(ModeSelection.theme),
                ),
                Selection(
                  onTap: () => onChooseMode(ModeSelection.rating),
                  icon: getIcon(ModeSelection.rating),
                  title: renderTitle(ModeSelection.rating),
                ),
                Selection(
                  onTap: () => onChooseMode(ModeSelection.language),
                  icon: getIcon(ModeSelection.language),
                  title: renderTitle(ModeSelection.language),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}