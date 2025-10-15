import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/constants.dart';
import 'package:food_recipe_app/model/notification_model.dart';
import 'package:food_recipe_app/services/notification/notification_data.dart';
import 'package:food_recipe_app/views/main/notification/notification_image_widget.dart';
import 'package:food_recipe_app/views/main/notification/notification_list.dart';
import 'package:food_recipe_app/widget/other/load_data.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _btnIndex = 0;
  bool get isRead => _btnIndex == 1;
  final nData = NotificationData();
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
      default:
        return SizedBox();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: IconButton(
            onPressed: () => Navigator.pop(context), 
            icon: Icon(Icons.arrow_back, size: 20)
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.white,
        title: Text("Thông báo",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700
          ),
        ),
      ),
      body: Column(
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
                    color: _btnIndex == 0 ? AppColors.green : AppColors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Text(
                      "Tất cả",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _btnIndex == 0 ? AppColors.white : AppColors.black,
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
                    color: _btnIndex == 1 ? AppColors.green : AppColors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Text(
                      "Đã đọc",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _btnIndex == 1 ? AppColors.white : AppColors.black,
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
                    color: _btnIndex == 2 ? AppColors.green : AppColors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Text(
                      "Chưa đọc",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _btnIndex == 2 ? AppColors.white : AppColors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          FutureBuilder(
            future: _btnIndex == 0 
              ? nData.getSystemNotifications() 
              : nData.getReadNotifications(isRead), 
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
                      notifications[index].from!
                    ), 
                    title: notifications[index].title, 
                    date: DateFormat("dd/MM/yyyy").format(notifications[index].createdAt)
                  ),
                );
              }
            }
          )
        ],
      ),
    );
  }
}