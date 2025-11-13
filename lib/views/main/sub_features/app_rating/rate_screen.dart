import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/constants.dart';
import 'package:food_recipe_app/common/convert.dart';
import 'package:food_recipe_app/model/rating_model.dart';
import 'package:food_recipe_app/widget/other/message.dart';
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
      rate = widget.rating!.ratingStar;
      contentController.text = widget.rating!.content;
    }
  }
  void onDirectRating() async{
    context.loaderOverlay.show();
    RatingModel rating = RatingModel(
      ratingId: generateRandomString(20), 
      userId: currentUser.uid, 
      avatar: currentUser.photoURL!, 
      userName: currentUser.displayName!, 
      ratingStar: rate, 
      content: contentController.text, 
      createdAt: DateTime.now(), 
      likes: []
    );
    await rateServices.addRating(context, rating).then((_){
      context.loaderOverlay.hide();
      Message.showScaffoldMessage(context, "Cảm ơn bạn đã đánh giá", AppColors.green);
      Navigator.pop(context);
    });
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
          "Đánh giá ứng dụng",
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
              child: radio(context, rates.first),
            ),
            SizedBox(height: 20),
            Visibility(
              visible: selectRatingMethod == rates.first,
              child: Column(
                children: [
                  RatingBar.builder(
                    direction: Axis.horizontal,
                    maxRating: 1,
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
                    "Đánh giá: $rate/5.0",
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontSize: 14,
                      fontWeight: FontWeight.normal
                    ),
                  ),
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: theme.colorScheme.secondary)
                      ),
                      hintText: "Nhận xét (Không bắt buộc)",
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
                        "Xác nhận",
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
              child: radio(context, rates.last),
            ),
            SizedBox(height: 20),
            Visibility(
              visible: selectRatingMethod == rates.last,
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
                    "Đi tới ${Platform.isAndroid ? "Google Play" : "App Store"}",
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
  Widget radio(BuildContext context, String title){
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Radio<String>(
        activeColor: theme.colorScheme.secondary,
        value: title,
        groupValue: selectRatingMethod,
        onChanged: (value) {
          setState(() {
            selectRatingMethod = value;
          });
        },
      ),
      title: Text(
        title,
        style: TextStyle(
          color: theme.colorScheme.secondary,
          fontSize: 12,
          fontWeight: FontWeight.normal
        ),
      ),
      onTap: () {
        setState(() {
          selectRatingMethod = title;
        });
      },
    );
  }
}