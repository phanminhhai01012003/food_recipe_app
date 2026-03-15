import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';

class NoData extends StatelessWidget {
  const NoData({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error, 
            size: 50, 
            color: AppColors.red
          ),
          SizedBox(height: 10),
          Text(
            "noData".tr(),
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: 14,
              fontWeight: FontWeight.normal
            ),
          )
        ],
      ),
    );
  }
}
