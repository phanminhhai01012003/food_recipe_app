import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/configure/routes.dart';
import 'package:food_recipe_app/model/comment_model.dart';
import 'package:food_recipe_app/model/food_model.dart';

class NotificationList extends StatefulWidget {
  final Widget imageWidget;
  final String title;
  final String body;
  final String date;
  final bool isRead;
  final String type;
  final String? androidImageUrl;
  final String? iosImageUrl;
  final Map<String, dynamic>? mainData;
  final Map<String, dynamic>? extraData;
  const NotificationList({
    super.key, 
    required this.imageWidget, 
    required this.title,
    required this.body, 
    required this.date,
    required this.isRead,
    required this.type,
    this.androidImageUrl,
    this.iosImageUrl,
    this.mainData,
    this.extraData
  });

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  void onClickNotification(String type){
    switch(type){
      case "Thích bài viết":
        Navigator.push(context, checkDeviceRoute(foodDetailPage(FoodModel.fromMap(widget.mainData ?? {}))));
        break;
      case "Bình luận bài viết" || "Thích bình luận":
        Navigator.push(context, checkDeviceRoute(commentPage(FoodModel.fromMap(widget.mainData ?? {}))));
        break;
      case "Trả lời bình luận":
        Navigator.push(context, checkDeviceRoute(replyPage(CommentModel.fromMap(widget.mainData ?? {}), FoodModel.fromMap(widget.extraData ?? {}))));
        break;
      case "Hệ thống":
        Navigator.push(context, 
          checkDeviceRoute(
            notificationInform(
              widget.title, 
              widget.body, 
              widget.androidImageUrl, 
              widget.iosImageUrl
            )
          )
        );
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => onClickNotification(widget.type),
      child: Container(
        color: theme.colorScheme.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                widget.imageWidget,
                SizedBox(width: 5),
                Expanded(
                  child: Text(
                    widget.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontSize: 12,
                      fontWeight: widget.isRead ? FontWeight.w800 : FontWeight.w400
                    ),
                  ),
                ),         
              ],
            ),
            Text(
              widget.date,
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 10,
                fontWeight: widget.isRead ? FontWeight.w800 : FontWeight.w400
              ),
            ),
          ],
        ),
      ),
    );
  }
}