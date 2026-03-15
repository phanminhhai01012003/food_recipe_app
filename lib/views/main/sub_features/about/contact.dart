import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/configure/logger.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_assets.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:url_launcher/url_launcher.dart';

class Contact extends StatelessWidget {
  const Contact({super.key});

  Future<void> launchFacebook() async{
    String fbId = "695600733639360";
    String fbWebUrl = "https://www.facebook.com/phan.minh.hai.82456";
    String fbAppUrl = Platform.isAndroid ? "fb://facewebmodal/f?href=$fbWebUrl" : "fb://profile/$fbId";
    try {
      Uri appUri = Uri.parse(fbAppUrl);
      Uri webUri = Uri.parse(fbWebUrl);
      bool canLaunchApp = await canLaunchUrl(appUri);
      if (canLaunchApp) {
        await launchUrl(appUri, mode: LaunchMode.externalApplication).then((value) => Logger.log(value));
      } else {
        await launchUrl(webUri, mode: LaunchMode.externalApplication).then((value) => Logger.log(value));
      }
    } catch (e) {
      Message.showToast("shortError".tr());
      Logger.log("Error to launch Facebook: $e");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        children: [
          Image.asset(foodDesignImage,
            width: MediaQuery.of(context).size.width * 0.5,
            height: 100,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 20),
          Text(
            "PMH Food Recipe",
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: 28,
              fontWeight: FontWeight.w900
            ),
          ),
          SizedBox(height: 20),
          Text(
            "${"createdBy".tr()} Phan Minh Hai",
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: 20,
              fontWeight: FontWeight.w300
            ),
          ),
          SizedBox(height: 20),
          Text(
            "${"version".tr()} 1.0",
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: 20,
              fontWeight: FontWeight.w300
            ),
          ),
          SizedBox(height: 20),
          Text(
            "contactInfo".tr(),
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: 20,
              fontWeight: FontWeight.w300
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Icon(
                Icons.email,
                size: 20,
                color: theme.colorScheme.secondary,
              ),
              SizedBox(width: 5),
              Text(
                "phanminhai012003@gmail.com",
                style: TextStyle(
                  color: theme.colorScheme.secondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w300
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Icon(
                Icons.phone,
                size: 20,
                color: theme.colorScheme.secondary,
              ),
              SizedBox(width: 5),
              Text(
                "0984238803",
                style: TextStyle(
                  color: theme.colorScheme.secondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w300
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Image.asset(
                fbImage,
                width: 20,
                height: 20,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 5),
              TextButton(
                onPressed: () => launchFacebook(),
                child: Text(
                  "Phan Minh Hải",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: AppColors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.w300
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}