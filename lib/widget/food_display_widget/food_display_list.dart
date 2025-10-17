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

class FoodDisplayList extends StatefulWidget {
  final FoodModel food;
  const FoodDisplayList({super.key, required this.food});

  @override
  State<FoodDisplayList> createState() => _FoodDisplayListState();
}

class _FoodDisplayListState extends State<FoodDisplayList> {
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
        width: double.infinity,
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
        child: Row(
          children: [
            Hero(
              tag: widget.food.image,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  imageUrl: widget.food.image,
                  progressIndicatorBuilder: (context, url, progress) => Center(
                    child: CircularProgressIndicator(
                      value: progress.progress,
                      color: AppColors.yellow,
                    )
                  ),
                  fadeInCurve: Curves.linear,
                  fadeInDuration: Duration(seconds: 2),
                  errorWidget: (context, url, error) => Image.asset(foodDesignImage),
                ),
              ),
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.food.title,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  widget.food.userName,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400
                  ),
                )
              ],
            ),
          ],
        )
      ),
    );
  }
}