import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/constants.dart';
import 'package:food_recipe_app/model/user_model.dart';

class UserWidget extends StatefulWidget {
  final VoidCallback onTap;
  final UserModel user;
  const UserWidget({super.key, required this.user, required this.onTap});

  @override
  State<UserWidget> createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
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
              child: CachedNetworkImage(
                imageUrl: widget.user.avatar,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Image.asset(userDefaultImage),
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.userName,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  widget.user.email,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
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