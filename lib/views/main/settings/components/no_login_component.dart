import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_assets.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';

class NoLoginComponent extends StatefulWidget {
  final VoidCallback onTap;
  const NoLoginComponent({super.key, required this.onTap});

  @override
  State<NoLoginComponent> createState() => _NoLoginComponentState();
}

class _NoLoginComponentState extends State<NoLoginComponent> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.green,
          borderRadius: BorderRadius.circular(12)
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle
              ),
              clipBehavior: Clip.hardEdge,
              child: Image.network(
                userDefaultImage,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "login".tr(),
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "pressToActive".tr(),
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}