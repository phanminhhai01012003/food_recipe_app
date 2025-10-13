import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_recipe_app/common/app_colors.dart';

class Message {
  static void showScaffoldMessage(BuildContext context, String title, Color color){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          title,
          style: TextStyle(
            color: AppColors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      )
    );
  }
  static void showToast(String title){
    Fluttertoast.showToast(
      msg: title,
      backgroundColor: AppColors.black,
      textColor: AppColors.white,
      toastLength: Toast.LENGTH_SHORT,
      fontSize: 16,
      gravity: ToastGravity.BOTTOM
    );
  }
}