import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_assets.dart';

class Contact extends StatelessWidget {
  const Contact({super.key});

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
          Text("PMH Food Recipe",
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: 28,
              fontWeight: FontWeight.w900
            ),
          ),
          SizedBox(height: 50),
          Text("${"createdBy".tr()} Phan Minh Hai",
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: 20,
              fontWeight: FontWeight.w300
            ),
          ),
          SizedBox(height: 20),
          Text("${"version".tr()} 1.0",
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: 20,
              fontWeight: FontWeight.w300
            ),
          ),
          SizedBox(height: 20),
          Text("contactInfo".tr(),
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: 20,
              fontWeight: FontWeight.w300
            ),
          ),
          SizedBox(height: 20),
          Text("${"email".tr()}: phanminhai012003@gmail.com",
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: 20,
              fontWeight: FontWeight.w300
            ),
          ),
          SizedBox(height: 20),
          Text("${"phone".tr()}: 0984238803",
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: 20,
              fontWeight: FontWeight.w300
            ),
          ),
          SizedBox(height: 20),
          Text("${"name".tr()}: Phan Minh Hai",
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: 20,
              fontWeight: FontWeight.w300
            ),
          ),
        ],
      ),
    );
  }
}