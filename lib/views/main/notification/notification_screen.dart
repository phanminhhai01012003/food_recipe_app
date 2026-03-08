import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/constants/class_defined.dart';
import 'package:food_recipe_app/common/constants/firebase_constants.dart';
import 'package:food_recipe_app/common/extension/datetime_extension.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_assets.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/model/notification_model.dart';
import 'package:food_recipe_app/views/main/notification/notification_image_widget.dart';
import 'package:food_recipe_app/views/main/notification/notification_list.dart';
import 'package:food_recipe_app/widget/load_data/load_data.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _btnIndex = 0;
  Widget renderImageWidget(String type, String fromUserAvatar){
    switch(type) {
      case "Thích bài viết":
      case "Thích bình luận":
        return NotificationImageWidget(
          icon: Icons.thumb_up_rounded, 
          fromUserAvatar: fromUserAvatar, 
          color: AppColors.blue
        );
      case "Bình luận bài viết":
      case "Trả lời bình luận":
        return NotificationImageWidget(
          icon: Icons.comment_sharp, 
          fromUserAvatar: fromUserAvatar, 
          color: AppColors.green
        );
      case "Hệ thống":
        return Container(
          width: 35,
          height: 35,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: Image.asset(foodDesignImage, fit: BoxFit.cover),
        );
      case "Theo dõi":
        return NotificationImageWidget(
          icon: Icons.face, 
          fromUserAvatar: fromUserAvatar, 
          color: AppColors.green
        );
      default:
        return SizedBox();
    }
  }
  Future<List<NotificationModel>> getNotifications() {
    if (_btnIndex == 0){
      return notificationData.getAllNotifications();
    } else if (_btnIndex == 1){
      return notificationData.getSystemNotifications("Hệ thống");
    } else {
      return notificationData.getSpecificUserNotifications(currentUser.displayName ?? "");
    }
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: IconButton(
            onPressed: () => Navigator.pop(context), 
            icon: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios, 
              size: 20
            )
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        title: Text("notification".tr(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: (){
                    setState(() {
                      _btnIndex = 0;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.25,
                    decoration: BoxDecoration(
                      color: _btnIndex == 0 ? AppColors.green : theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: Text(
                        "all".tr(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _btnIndex == 0 ? AppColors.white : theme.colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    setState(() {
                      _btnIndex = 1;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.25,
                    decoration: BoxDecoration(
                      color: _btnIndex == 1 ? AppColors.green : theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: Text(
                        "fromSystem".tr(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _btnIndex == 1 ? AppColors.white : theme.colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    setState(() {
                      _btnIndex = 2;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.25,
                    decoration: BoxDecoration(
                      color: _btnIndex == 2 ? AppColors.green : theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: Text(
                        "interaction".tr(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _btnIndex == 2 ? AppColors.white : theme.colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            FutureBuilder(
              future: getNotifications(), 
              builder: (context, snapshot){
                if (!snapshot.hasData || snapshot.hasError){
                  return SizedBox.shrink();
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadData(isList: true);
                } else {
                  List<NotificationModel> notifications = snapshot.data!;
                  return ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: notifications.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1, 
                      thickness: 1, 
                      color: AppColors.grey
                    ),
                    itemBuilder: (context, index) => NotificationList(
                      imageWidget: renderImageWidget(
                        notifications[index].type, 
                        notifications[index].from!,
                      ), 
                      title: notifications[index].title,
                      body: notifications[index].body,
                      date: notifications[index].createdAt.ddmmyyyy,
                      isRead: notifications[index].isRead,
                      type: notifications[index].type,
                      androidImageUrl: notifications[index].androidImageUrl,
                      iosImageUrl: notifications[index].iosImageUrl,
                      mainData: notifications[index].mainData,
                      extraData: notifications[index].extraData,
                    ),
                  );
                }
              }
            )
          ],
        ),
      ),
    );
  }
}