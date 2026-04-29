import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/utils/logger.dart';
import 'package:food_recipe_app/common/utils/routes.dart';
import 'package:food_recipe_app/common/constants/class_defined.dart';
import 'package:food_recipe_app/common/constants/firebase_constants.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:loader_overlay/loader_overlay.dart';

void confirmAndroid(BuildContext context, bool isObscured, VoidCallback onClick){
  final passwordController = TextEditingController();
  final theme = Theme.of(context);
  showDialog(
    context: context, 
    builder: (context) => AlertDialog(
      backgroundColor: theme.colorScheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(
        "deleteUserConfirm".tr(),
        style: TextStyle(
          color: theme.colorScheme.secondary,
          fontWeight: FontWeight.bold,
          fontSize: 18
        ),
      ),
      content: Column(
        children: [
          Text(
            "passwordConfirmBeforeDeleting".tr(),
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.bold,
              fontSize: 18
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: passwordController,
            obscureText: isObscured,
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: 12,
              fontWeight: FontWeight.w700
            ),
            cursorColor: AppColors.blue,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: theme.colorScheme.secondary)
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.red)
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.green)
              ),
              hintText: "passwordInput".tr(),
              hintStyle: TextStyle(
                color: AppColors.black,
                fontSize: 12,
                fontWeight: FontWeight.normal
              ),
              prefixIcon: Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                child: Icon(Icons.lock, color: theme.colorScheme.secondary)
              ),
              suffixIcon: IconButton(
                onPressed: onClick, 
                icon: Icon(
                  isObscured ? Icons.visibility : Icons.visibility_off,
                  size: 20,
                )
              )
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "passwordEmpty".tr();
              } 
              if (value.length < 6){
                return "passwordInvalid1".tr();
              }
              return null;
            },
          )
        ],
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.blue,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
          ),
          onPressed: () => onDeleteAccountDirectly(context, currentUser.email ?? "", passwordController.text),
          child: Text("confirm".tr(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700
            ),
          )
        ),
        TextButton(
          onPressed: () => Navigator.pop(context), 
          child: Text("cancel".tr(), 
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: 14,
              fontWeight: FontWeight.w700
            )
          )
        )
      ],
    )
  );
}

void confirmIOS(BuildContext context, bool isObscured, VoidCallback onClick){
  final passwordController = TextEditingController();
  final theme = Theme.of(context);
  showCupertinoDialog(
    context: context, 
    builder: (context) => CupertinoAlertDialog(
      title: Text(
        "deleteUserConfirm".tr(),
        style: TextStyle(
          color: theme.colorScheme.secondary,
          fontWeight: FontWeight.bold,
          fontSize: 18
        ),
      ),
      content: Column(
        children: [
          Text(
            "passwordConfirmBeforeDeleting".tr(),
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.bold,
              fontSize: 18
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: passwordController,
            obscureText: isObscured,
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: 12,
              fontWeight: FontWeight.w700
            ),
            cursorColor: AppColors.blue,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: theme.colorScheme.secondary)
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.red)
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.green)
              ),
              hintText: "passwordInput".tr(),
              hintStyle: TextStyle(
                color: AppColors.black,
                fontSize: 12,
                fontWeight: FontWeight.normal
              ),
              prefixIcon: Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                child: Icon(Icons.lock, color: theme.colorScheme.secondary)
              ),
              suffixIcon: IconButton(
                onPressed: onClick, 
                icon: Icon(
                  isObscured ? Icons.visibility : Icons.visibility_off,
                  size: 20,
                )
              )
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "passwordEmpty".tr();
              } 
              if (value.length < 6){
                return "passwordInvalid1".tr();
              }
              return null;
            },
          )
        ],
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () => onDeleteAccountDirectly(context, currentUser.email ?? "", passwordController.text),
          child: Text("confirm".tr(), 
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: 14,
              fontWeight: FontWeight.w700
            )
          )
        ),
        CupertinoDialogAction(
          onPressed: () => Navigator.pop(context), 
          child: Text("cancel".tr(), 
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: 14,
              fontWeight: FontWeight.w700
            )
          )
        )
      ],
    )
  );
}

Future<void> onDeleteAccountDirectly(BuildContext context, String email, String password) async{
  context.loaderOverlay.show();
  await Future.delayed(Duration(seconds: 2));
  try {    
    AuthCredential credential = EmailAuthProvider.credential(
      email: email, 
      password: password
    );
    await currentUser.reauthenticateWithCredential(credential).then((value) async{
      await Future.wait([
        followServices.removeFollowUsers(context, value.user!.uid),
        userServices.deleteUser(context, value.user!.uid),
        authServices.deleteAccount(context)
      ]);
    });       
    context.loaderOverlay.hide();
    Message.showScaffoldMessage(context, "deleteOldAcc".tr(), AppColors.green);
    Navigator.pushAndRemoveUntil(context, checkDeviceRoute(loginPage), (route) => false);
  } catch (e) {
    Message.showScaffoldMessage(context, "longError".tr(), AppColors.red);
    Logger.log(e);
    context.loaderOverlay.hide();
    return;
  }
}

void confirmPasswordDialog(BuildContext context, bool isObscured, VoidCallback onClick){
  Platform.isAndroid 
    ? confirmAndroid(context, isObscured, onClick) 
    : confirmIOS(context, isObscured, onClick);
}