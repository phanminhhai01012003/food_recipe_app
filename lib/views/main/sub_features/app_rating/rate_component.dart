import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/constants/firebase_constants.dart';
import 'package:food_recipe_app/common/extension/datetime_extension.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/common/configure/routes.dart';
import 'package:food_recipe_app/model/rating_model.dart';
import 'package:food_recipe_app/views/main/sub_features/app_rating/rating_selection.dart';

class RateComponent extends StatefulWidget {
  final RatingModel rate;
  const RateComponent({super.key, required this.rate});

  @override
  State<RateComponent> createState() => _RateComponentState();
}

class _RateComponentState extends State<RateComponent> {
  bool isLikedRate = false;
  void toggleLikeRating(){
    setState(() {
      isLikedRate = !isLikedRate;
    });
    if (isLikedRate){
      rateCollection.doc(widget.rate.ratingId).update({
        "likes": FieldValue.arrayUnion([{
          "id": currentUser.uid,
          "avatar": currentUser.photoURL,
          "username": currentUser.displayName
        }])
      });
    } else {
      rateCollection.doc(widget.rate.ratingId).update({
        "likes": FieldValue.arrayRemove([{
          "id": currentUser.uid,
          "avatar": currentUser.photoURL,
          "username": currentUser.displayName
        }])
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onLongPress: () => widget.rate.userId == currentUser.uid 
        ? RatingSelection.showCurrentUserRateSelection(context, widget.rate)
        : RatingSelection.showGeneralRateSelection(context, widget.rate),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary,
              offset: Offset(5, 5),
              blurRadius: 5,
              spreadRadius: 5,
              blurStyle: BlurStyle.solid
            ),
            BoxShadow(
              color: theme.colorScheme.primary,
              offset: Offset(4, 2),
              blurRadius: 3,
              spreadRadius: 3,
              blurStyle: BlurStyle.solid
            )
          ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(context, checkDeviceRoute(personalScreen(widget.rate.userId))),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CachedNetworkImage(
                          imageUrl: widget.rate.avatar,
                          progressIndicatorBuilder: (context, url, progress) => Center(
                            child: CircularProgressIndicator(
                              value: progress.progress,
                              color: AppColors.yellow,
                            )
                          ),
                          fit: BoxFit.cover,
                          width: 33,
                          height: 33,
                          errorWidget: (context, url, error) => Center(
                            child: Icon(
                              Icons.error,
                              size: 20,
                              color: AppColors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      widget.rate.userName,
                      style: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                    SizedBox(width: 10),
                    Visibility(
                      visible: widget.rate.userId == currentUser.uid,
                      child: Text(
                        "me".tr(),
                        style: TextStyle(
                          backgroundColor: AppColors.blue,
                          color: AppColors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 20,
                      color: AppColors.yellow,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "${widget.rate.ratingStar}",
                      style: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      widget.rate.createdAt.ddmmyyyy,
                      style: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                      ),
                    )
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  widget.rate.content,
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700
                  ),
                )
              ],
            ),
            Column(
              children: [
                IconButton(
                  onPressed: toggleLikeRating, 
                  icon: Icon(
                    isLikedRate ? Icons.favorite : Icons.favorite_border,
                    size: 20,
                    color: isLikedRate ? AppColors.red : AppColors.grey,
                  )
                ),
                Text(
                  widget.rate.likes.length.toString(),
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w300
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