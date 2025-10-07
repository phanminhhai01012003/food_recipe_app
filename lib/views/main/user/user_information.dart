import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/constants.dart';
import 'package:food_recipe_app/common/routes.dart';
import 'package:food_recipe_app/model/user_model.dart';
import 'package:food_recipe_app/services/authentication/auth_services.dart';
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
  final authServices = AuthServices();
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
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.white,
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
                  errorWidget: (context, url, error) => Image.asset(userDefaultImage),
                ),
              ),
            ),
            SizedBox(height: 30),
            component("ID", widget.user.userId),
            SizedBox(height: 15),
            Divider(color: AppColors.grey, thickness: 1, height: 1),
            SizedBox(height: 15),
            component("Họ và tên", widget.user.userName),
            SizedBox(height: 15),
            Divider(color: AppColors.grey, thickness: 1, height: 1),
            SizedBox(height: 15),
            component("Giới thiệu", widget.user.description),
            SizedBox(height: 15),
            Divider(color: AppColors.grey, thickness: 1, height: 1),
            SizedBox(height: 15),
            component("Số điện thoại", widget.user.phone),
            SizedBox(height: 15),
            Divider(color: AppColors.grey, thickness: 1, height: 1),
            SizedBox(height: 15),
            component("Email", widget.user.email),
            SizedBox(height: 30),
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
              width: MediaQuery.of(context).size.width * 0.75,
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
  Widget component(String title, String info){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          textAlign: TextAlign.start,
          style: TextStyle(
            color: AppColors.black,
            fontSize: 14,
            fontWeight: FontWeight.w700
          ),
        ),
        SizedBox(
          width: 100,
          child: Expanded(
            child: Text(
              info,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: AppColors.black,
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