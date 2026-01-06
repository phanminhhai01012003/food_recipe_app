import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/constants.dart';
import 'package:food_recipe_app/common/routes.dart';
import 'package:food_recipe_app/model/user_model.dart';
import 'package:food_recipe_app/widget/dialog/show_yesno_dialog.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:full_screen_image/full_screen_image.dart';

class UserInformation extends StatefulWidget {
  final UserModel user;
  const UserInformation({super.key, required this.user});

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  void onLogOut() async{
    if (widget.user.loginMethod == "Google") {
      await authServices.logOutFromGoogle(context).then((_){
        Message.showScaffoldMessage(context, "Đã đăng xuất khỏi hệ thống", AppColors.green);
        Navigator.pushAndRemoveUntil(
          context, 
          checkDeviceRoute(loginPage), 
          (route) => false
        );
      });
    } else if (widget.user.loginMethod == "Facebook") {
      await authServices.logOutFromFacebook(context).then((_){
        Message.showScaffoldMessage(context, "Đã đăng xuất khỏi hệ thống", AppColors.green);
        Navigator.pushAndRemoveUntil(
          context, 
          checkDeviceRoute(loginPage), 
          (route) => false
        );
      });
    } else {
      await authServices.logOutFromAccount(context).then((_){
        Message.showScaffoldMessage(context, "Đã đăng xuất khỏi hệ thống", AppColors.green);
        Navigator.pushAndRemoveUntil(
          context, 
          checkDeviceRoute(loginPage), 
          (route) => false
        );
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
          "Thông tin cá nhân",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            FullScreenWidget(
              disposeLevel: DisposeLevel.Medium,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                  imageUrl: widget.user.avatar,
                  progressIndicatorBuilder: (context, url, progress) => Center(child: CircularProgressIndicator(value: progress.progress)),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Center(
                    child: Icon(
                      Icons.error,
                      size: 30,
                      color: AppColors.grey,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            component(context, "ID", widget.user.userId),
            SizedBox(height: 15),
            Divider(color: AppColors.grey, thickness: 1, height: 1),
            SizedBox(height: 15),
            component(context, "Họ và tên", widget.user.userName),
            SizedBox(height: 15),
            Divider(color: AppColors.grey, thickness: 1, height: 1),
            SizedBox(height: 15),
            component(context, "Biệt danh", widget.user.nickName),
            SizedBox(height: 15),
            Divider(color: AppColors.grey, thickness: 1, height: 1),
            SizedBox(height: 15),
            component(context, "Giới thiệu", widget.user.description),
            SizedBox(height: 15),
            Divider(color: AppColors.grey, thickness: 1, height: 1),
            SizedBox(height: 15),
            component(context, "Số điện thoại", widget.user.phone),
            SizedBox(height: 15),
            Divider(color: AppColors.grey, thickness: 1, height: 1),
            SizedBox(height: 15),
            component(context, "Email", widget.user.email),
            SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yellow,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(33))
                ),
                onPressed: () => Navigator.push(context, checkDeviceRoute(editUserPage(widget.user))), 
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_2, size: 20),
                    SizedBox(width: 5),
                    Text(
                      "Chỉnh sửa thông tin",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800
                      ),
                    ),
                  ],
                )
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(33))
                ),
                onPressed: () => Navigator.push(context, checkDeviceRoute(deleteUser)), 
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete_forever, size: 20),
                    SizedBox(width: 5),
                    Text(
                      "Xóa tài khoản",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800
                      ),
                    ),
                  ],
                )
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.purple,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(33))
                ),
                onPressed: () => ShowYesnoDialog.checkDeviceDialog(
                  context, 
                  title: "Đăng xuất", 
                  content: "Bạn có chắc chắn muốn đăng xuất khỏi hệ thống không?", 
                  onAcceptTap: () => onLogOut(), 
                  onCancelTap: () => Navigator.pop(context)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, size: 20),
                    SizedBox(width: 5),
                    Text("Đăng xuất",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget component(BuildContext context, String title, String info){
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          textAlign: TextAlign.start,
          style: TextStyle(
            color: theme.colorScheme.secondary,
            fontSize: 14,
            fontWeight: FontWeight.w700
          ),
        ),
        SizedBox(
          width: 200,
          child: Expanded(
            child: Text(
              info,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 14,
                fontWeight: FontWeight.w700
              ),
            ),
          ),
        )
      ],
    );
  }
}