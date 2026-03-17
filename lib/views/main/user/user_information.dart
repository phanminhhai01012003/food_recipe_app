import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/constants/class_defined.dart';
import 'package:food_recipe_app/common/constants/firebase_constants.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/common/configure/routes.dart';
import 'package:food_recipe_app/model/user_model.dart';
import 'package:food_recipe_app/widget/full_screen_image/show_image_sheet.dart';
import 'package:food_recipe_app/views/main/user/get_follow_data.dart';
import 'package:food_recipe_app/widget/bottom_sheet/show_report_modal.dart';
import 'package:food_recipe_app/widget/dialog/show_yesno_dialog.dart';
import 'package:food_recipe_app/widget/other/message.dart';

class UserInformation extends StatefulWidget {
  final UserModel user;
  const UserInformation({super.key, required this.user});

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  void onLogOut() async{
    if (widget.user.loginMethod == "Google") {
      await authServices.logOutFromGoogle(context).then((_){
        Message.showScaffoldMessage(context, "signOutSuccess".tr(), AppColors.green);
        Navigator.pushAndRemoveUntil(
          context, 
          checkDeviceRoute(loginPage), 
          (route) => false
        );
      });
    } else if (widget.user.loginMethod == "Facebook") {
      await authServices.logOutFromFacebook(context).then((_){
        Message.showScaffoldMessage(context, "signOutSuccess".tr(), AppColors.green);
        Navigator.pushAndRemoveUntil(
          context, 
          checkDeviceRoute(loginPage), 
          (route) => false
        );
      });
    } else {
      await authServices.logOutFromAccount(context).then((_){
        Message.showScaffoldMessage(context, "signOutSuccess".tr(), AppColors.green);
        Navigator.pushAndRemoveUntil(
          context, 
          checkDeviceRoute(loginPage), 
          (route) => false
        );
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
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
        title: Text(
          "userInformation".tr(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context, checkDeviceRoute(stats)),
            icon: Icon(
              Icons.bar_chart_rounded,
              size: 20,
            ),
          )
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async => await showImageChoiceBottomSheet(context, widget.user.avatar),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                  imageUrl: widget.user.avatar,
                  progressIndicatorBuilder: (context, url, progress) => Center(child: CircularProgressIndicator(value: progress.progress)),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Center(
                    child: Icon(
                      Icons.error,
                      size: 30,
                      color: AppColors.grey,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            GetFollowData(user: widget.user),
            component(context, "id".tr(), widget.user.userId),
            divider(),
            component(context, "name".tr(), widget.user.userName),
            divider(),
            component(context, "nickName".tr(), widget.user.nickName),
            divider(),
            component(context, "description1".tr(), widget.user.description),
            divider(),
            component(context, "phone".tr(), widget.user.phone == "unknown" ? "unknown".tr() : widget.user.phone),
            divider(),
            component(context, "email".tr(), widget.user.email),
            SizedBox(height: 30),
            Visibility(
              visible: widget.user.userId == currentUser.uid,
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellow,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(33))
                  ),
                  onPressed: () => Navigator.push(context, checkDeviceRoute(editUserPage(widget.user))), 
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_2, size: 20),
                      SizedBox(width: 5),
                      Text(
                        "editUser".tr(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800
                        ),
                      ),
                    ],
                  )
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(33))
                ),
                onPressed: () async{
                  if (widget.user.userId == currentUser.uid) {
                    Navigator.push(context, checkDeviceRoute(deleteUser(widget.user.loginMethod)));
                  } else {
                    await showReportModal(context, "user".tr(), widget.user.userName, null);
                  }
                }, 
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.user.userId == currentUser.uid ? Icons.delete_forever : Icons.report, 
                      size: 20
                    ),
                    SizedBox(width: 5),
                    Text(
                      widget.user.userId == currentUser.uid ? "deleteAcc".tr() : "report".tr(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800
                      ),
                    ),
                  ],
                )
              ),
            ),
            SizedBox(height: 10),
            Visibility(
              visible: widget.user.userId == currentUser.uid,
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.purple,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(33))
                  ),
                  onPressed: () => ShowYesnoDialog.checkDeviceDialog(
                    context, 
                    title: "signOut".tr(), 
                    content: "signOutDesc".tr(), 
                    onAcceptTap: () => onLogOut(), 
                    onCancelTap: () => Navigator.pop(context)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, size: 20),
                      SizedBox(width: 5),
                      Text("signOut".tr(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget component(BuildContext context, String title, String info){
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          textAlign: TextAlign.start,
          style: TextStyle(
            color: theme.colorScheme.secondary,
            fontSize: 14,
            fontWeight: FontWeight.w700
          ),
        ),
        SizedBox(
          width: 200,
          child: Expanded(
            child: Text(
              info,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 14,
                fontWeight: FontWeight.w700
              ),
            ),
          ),
        )
      ],
    );
  }
  Widget divider() {
    return Column(
      children: [
        SizedBox(height: 15),
        Divider(color: AppColors.grey, thickness: 1, height: 1),
        SizedBox(height: 15),
      ],
    );
  }
}