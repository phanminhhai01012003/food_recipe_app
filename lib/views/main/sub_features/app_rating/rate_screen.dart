import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_recipe_app/common/constants/class_defined.dart';
import 'package:food_recipe_app/common/constants/firebase_constants.dart';
import 'package:food_recipe_app/common/constants/list_constants.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/common/utils/convert.dart';
import 'package:food_recipe_app/model/rating_model.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:food_recipe_app/widget/other/radio_selection.dart';
import 'package:loader_overlay/loader_overlay.dart';

class RateScreen extends StatefulWidget {
  final RatingModel? rating;
  const RateScreen({super.key, required this.rating});

  @override
  State<RateScreen> createState() => _RateScreenState();
}

class _RateScreenState extends State<RateScreen> {
  String? selectRatingMethod;
  double rate = 0;
  final contentController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.rating != null) {
      selectRatingMethod = rates.first;
      rate = widget.rating!.ratingStar;
      contentController.text = widget.rating!.content;
    }
  }
  void onDirectRating() async{
    context.loaderOverlay.show();
    await Future.delayed(Duration(seconds: 2));
    RatingModel rating = RatingModel(
      ratingId: widget.rating == null ? generateRandomString(20) : widget.rating!.ratingId, 
      userId: widget.rating == null ? currentUser.uid : widget.rating!.userId, 
      avatar: widget.rating == null ? (currentUser.photoURL ?? "") : widget.rating!.avatar, 
      userName: widget.rating == null ? (currentUser.displayName ?? "") : widget.rating!.userName, 
      ratingStar: rate, 
      content: contentController.text, 
      createdAt: widget.rating == null ? DateTime.now() : widget.rating!.createdAt, 
      likes: widget.rating == null ? [] : widget.rating!.likes
    );
    if (widget.rating == null) {
      await rateServices.addRating(context, rating).then((_){
        context.loaderOverlay.hide();
        Message.showScaffoldMessage(context, "rateSuccess".tr(), AppColors.green);
        Navigator.pop(context);
      });
    } else {
      await rateServices.updateRating(context, rating).then((_){
        context.loaderOverlay.hide();
        Message.showScaffoldMessage(context, "updateSuccess".tr(), AppColors.green);
        Navigator.pop(context);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: IconButton(
            onPressed: () => Navigator.pop(context), 
            icon: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
              size: 20,
            )
          ),
        ),
        title: Text(
          "rateApp".tr(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: RadioSelection(
                title: rates.first.tr(), 
                selectedOption: selectRatingMethod, 
                onTap: () {
                  setState(() {
                    selectRatingMethod = rates.first;
                  });
                }, 
                onChanged: (value) {
                  setState(() {
                    selectRatingMethod = value;
                  });
                }
              ),
            ),
            SizedBox(height: 20),
            Visibility(
              visible: selectRatingMethod == rates.first.tr(),
              child: Column(
                children: [
                  RatingBar.builder(
                    direction: Axis.horizontal,
                    minRating: 1,
                    initialRating: rate,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4),
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: AppColors.yellow,
                    ), 
                    onRatingUpdate: (value) {
                      setState(() {
                        rate = value;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  Text(
                    "${"rate".tr()}: $rate/5.0",
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontSize: 14,
                      fontWeight: FontWeight.normal
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: contentController,
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700
                    ),
                    cursorColor: AppColors.blue,
                    minLines: 3,
                    maxLines: 3,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.green)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: theme.colorScheme.secondary)
                      ),
                      hintText: "opinion".tr(),
                      hintStyle: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700
                      )
                    ),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                        foregroundColor: AppColors.white
                      ),
                      onPressed: onDirectRating, 
                      child: Text(
                        "confirm".tr(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: RadioSelection(
                title: rates.last.tr(), 
                selectedOption: selectRatingMethod, 
                onTap: (){
                  setState(() {
                    selectRatingMethod = rates.last;
                  });
                }, 
                onChanged: (value) {
                  setState(() {
                    selectRatingMethod = value;
                  });
                }
              ),
            ),
            SizedBox(height: 20),
            Visibility(
              visible: selectRatingMethod == rates.last.tr(),
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    foregroundColor: AppColors.white
                  ),
                  onPressed: onDirectRating, 
                  child: Text(
                    "${"go".tr()} ${Platform.isAndroid ? "Google Play" : "App Store"}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}