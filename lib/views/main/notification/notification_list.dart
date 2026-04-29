import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/utils/routes.dart';
import 'package:food_recipe_app/common/constants/class_defined.dart';
import 'package:food_recipe_app/common/extension/datetime_extension.dart';
import 'package:food_recipe_app/model/comment_model.dart';
import 'package:food_recipe_app/model/food_model.dart';
import 'package:food_recipe_app/model/notification_model.dart';

class NotificationList extends StatefulWidget {
  final Widget imageWidget;
  final NotificationModel notifications;
  const NotificationList({
    super.key, 
    required this.imageWidget, 
    required this.notifications
  });

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  void onClickNotification(String type){
    notificationData.updateReadNotifications(widget.notifications.id);
    switch(type){
      case "Thích bài viết":
        Navigator.push(context, checkDeviceRoute(foodDetailPage(FoodModel.fromMap(widget.notifications.mainData ?? {}))));
        break;
      case "Bình luận bài viết" || "Thích bình luận":
        Navigator.push(context, checkDeviceRoute(commentPage(FoodModel.fromMap(widget.notifications.mainData ?? {}))));
        break;
      case "Trả lời bình luận":
        Navigator.push(context, checkDeviceRoute(replyPage(CommentModel.fromMap(widget.notifications.mainData ?? {}), FoodModel.fromMap(widget.notifications.extraData ?? {}))));
        break;
      case "Hệ thống" || "Cảnh cáo vi phạm":
        Navigator.push(context, 
          checkDeviceRoute(
            notificationInform(
              widget.notifications.title, 
              widget.notifications.body, 
              widget.notifications.androidImageUrl, 
              widget.notifications.iosImageUrl
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
      onTap: () => onClickNotification(widget.notifications.type),
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
                    widget.notifications.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontSize: 12,
                      fontWeight: widget.notifications.isRead ? FontWeight.w800 : FontWeight.w400
                    ),
                  ),
                ),         
              ],
            ),
            Text(
              widget.notifications.createdAt.ddmmyyyy,
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 10,
                fontWeight: widget.notifications.isRead ? FontWeight.w800 : FontWeight.w400
              ),
            ),
          ],
        ),
      ),
    );
  }
}