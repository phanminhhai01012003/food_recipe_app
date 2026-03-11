import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';

class ShowYesnoDialog {
  static void materialDialog(
    BuildContext context, {
    required String title,
    required String content,
    required VoidCallback onAcceptTap,
    required VoidCallback onCancelTap
  }){
    final theme = Theme.of(context);
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.primary,
        title: Text(title,
          style: TextStyle(
            color: theme.colorScheme.secondary,
            fontWeight: FontWeight.bold,
            fontSize: 18
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text(content,
          style: TextStyle(
            color: theme.colorScheme.secondary,
            fontSize: 14,
            fontWeight: FontWeight.normal
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
            ),
            onPressed: onAcceptTap,
            child: Text("yes".tr(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700
              ),
            )
          ),
          TextButton(
            onPressed: onCancelTap, 
            child: Text("no".tr(), 
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
  static void cupertinoDialog(
    BuildContext context, {
    required String title,
    required String content,
    required VoidCallback onAcceptTap,
    required VoidCallback onCancelTap
  }){
    final theme = Theme.of(context);
    showCupertinoDialog(
      context: context, 
      builder: (context) => CupertinoAlertDialog(
        title: Text(title,
          style: TextStyle(
            color: theme.colorScheme.secondary,
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
        ),
        content: Text(content,
          style: TextStyle(
            color: theme.colorScheme.secondary,
            fontSize: 14,
            fontWeight: FontWeight.normal
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: onAcceptTap,
            child: Text("yes".tr(), 
              style: TextStyle(
                color: AppColors.blue,
                fontSize: 14,
                fontWeight: FontWeight.w500
              )
            ),
          ),
          CupertinoDialogAction(
            onPressed: onCancelTap,
            child: Text("no".tr(), 
              style: TextStyle(
                color: AppColors.red,
                fontSize: 14,
                fontWeight: FontWeight.w500
              )
            ),
          )
        ],
      ),
    );
  }
  static void checkDeviceDialog(
    BuildContext context, {
    required String title,
    required String content,
    required VoidCallback onAcceptTap,
    required VoidCallback onCancelTap 
  }) {
    Platform.isAndroid ? materialDialog(
      context, 
      title: title, 
      content: content, 
      onAcceptTap: onAcceptTap, 
      onCancelTap: onCancelTap
    ) : cupertinoDialog(
      context, 
      title: title, 
      content: content, 
      onAcceptTap: onAcceptTap, 
      onCancelTap: onCancelTap
    );
  }
}