import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/constants.dart';
import 'package:food_recipe_app/common/convert.dart';
import 'package:food_recipe_app/common/routes.dart';
import 'package:food_recipe_app/model/food_model.dart';
import 'package:food_recipe_app/model/recent_view_model.dart';
import 'package:food_recipe_app/provider/history_state.dart';
import 'package:provider/provider.dart';

class FoodDisplayGrid extends StatefulWidget {
  final FoodModel food;
  const FoodDisplayGrid({super.key, required this.food});

  @override
  State<FoodDisplayGrid> createState() => _FoodDisplayGridState();
}

class _FoodDisplayGridState extends State<FoodDisplayGrid> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        RecentViewModel recents = RecentViewModel(
          viewId: generateRandomString(16),
          userId: currentUser.uid, 
          isViewed: true, 
          viewedAt: DateTime.now(), 
          foods: widget.food
        );
        context.read<HistoryState>().toggle(recents);
        Navigator.push(
          context,
          checkDeviceRoute(
            foodDetailPage(
              widget.food, 
              widget.food.foodId, 
              List<Map<String, dynamic>>.from(widget.food.likes)
            )
          )
        );
      },
      child: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.white,
              offset: Offset(5, 5),
              blurRadius: 5,
              spreadRadius: 5,
              blurStyle: BlurStyle.solid
            ),
            BoxShadow(
              color: AppColors.white,
              offset: Offset(4, 2),
              blurRadius: 3,
              spreadRadius: 3,
              blurStyle: BlurStyle.solid
            )
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: widget.food.image,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: widget.food.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 100,
                  progressIndicatorBuilder: (context, url, imageProgress) => Center(
                    child: CircularProgressIndicator(
                      value: imageProgress.progress,
                      color: AppColors.yellow,
                    )
                  ),
                  fadeInCurve: Curves.linear,
                  fadeInDuration: Duration(seconds: 2),
                  errorWidget: (context, url, error) => Image.asset(foodDesignImage),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(widget.food.title,
              style: TextStyle(
                color: AppColors.black,
                fontSize: 16,
                fontWeight: FontWeight.w700
              ),
            ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: widget.food.avatar,
                    fit: BoxFit.cover,
                    height: 30,
                    errorWidget: (context, url, error) => Image.asset(userDefaultImage),
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  widget.food.userName,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400
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