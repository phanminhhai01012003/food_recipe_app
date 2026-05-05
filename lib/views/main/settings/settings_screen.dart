import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/constants/class_defined.dart';
import 'package:food_recipe_app/common/constants/firebase_constants.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';

import 'package:food_recipe_app/common/utils/routes.dart';
import 'package:food_recipe_app/data/enum.dart';
import 'package:food_recipe_app/model/app/user_model.dart';
import 'package:food_recipe_app/views/main/settings/selection.dart';
import 'package:food_recipe_app/views/main/settings/user_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void onChooseMode(ModeSelection mode) async{
    switch(mode){
      case ModeSelection.report:
        Navigator.push(context, checkDeviceRoute(reportPage));
        break;
      case ModeSelection.changePassword:
        Navigator.push(context, checkDeviceRoute(changePasswordPage));
        break;
      case ModeSelection.rating:
        Navigator.push(context, checkDeviceRoute(fullRatingPage));
        break;
      case ModeSelection.settings:
        Navigator.push(context, checkDeviceRoute(settingsDetail));
        break;
    }
  }
  IconData getIcon(ModeSelection mode){
    switch (mode) {
      case ModeSelection.report:
        return Icons.report;
      case ModeSelection.changePassword:
        return Icons.lock;
      case ModeSelection.rating:
        return Icons.star;
      case ModeSelection.settings:
        return Icons.settings;
    }
  }
  String renderTitle(ModeSelection mode){
    switch (mode) {
      case ModeSelection.report:
        return "reportList".tr();
      case ModeSelection.changePassword:
        return "changePassword".tr();
      case ModeSelection.rating:
        return "rate".tr();
      case ModeSelection.settings:
        return "settings".tr(); 
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
                  onTap: () => onChooseMode(ModeSelection.rating),
                  icon: getIcon(ModeSelection.rating),
                  title: renderTitle(ModeSelection.rating),
                ),
                Selection(
                  onTap: () => onChooseMode(ModeSelection.settings),
                  icon: getIcon(ModeSelection.settings),
                  title: renderTitle(ModeSelection.settings),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}