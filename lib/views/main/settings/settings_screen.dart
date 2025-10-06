import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/routes.dart';
import 'package:food_recipe_app/data/enum.dart';
import 'package:food_recipe_app/model/user_model.dart';
import 'package:food_recipe_app/services/authentication/auth_services.dart';
import 'package:food_recipe_app/services/firestore/user/user_services.dart';
import 'package:food_recipe_app/views/main/settings/selection.dart';
import 'package:food_recipe_app/views/main/settings/user_widget.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:food_recipe_app/widget/dialog/show_yesno_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final userServices = UserServices();
  final authServices = AuthServices();
  final _currentUser = FirebaseAuth.instance.currentUser;
  void onLogOut() async{
    await authServices.logOut(context).then((_){
      Message.showScaffoldMessage(context, "Đã đăng xuất khỏi hệ thống", AppColors.green);
      Navigator.pushAndRemoveUntil(
        context, 
        checkDeviceRoute(loginPage), 
        (route) => false
      );
    });
  }
  void onChooseMode(ModeSelection mode){
    switch(mode){
      case ModeSelection.about:
        Navigator.push(context, checkDeviceRoute(about));
      case ModeSelection.storage:
        Navigator.push(context, checkDeviceRoute(foodStorageView));
      case ModeSelection.report:
        Navigator.push(context, checkDeviceRoute(reportPage));
      case ModeSelection.changePassword:
        Navigator.push(context, checkDeviceRoute(changePasswordPage));
      case ModeSelection.theme:
        Navigator.push(context, checkDeviceRoute(changeThemeScreen));
    }
  }
  IconData getIcon(ModeSelection mode){
    switch (mode) {
      case ModeSelection.about:
        return Icons.info;
      case ModeSelection.storage:
        return Icons.storage;
      case ModeSelection.report:
        return Icons.report;
      case ModeSelection.changePassword:
        return Icons.lock;
      case ModeSelection.theme:
        return Icons.sunny;
    }
  }
  String renderTitle(ModeSelection mode){
    switch (mode) {
      case ModeSelection.about:
        return "Giới thiệu";
      case ModeSelection.storage:
        return "Kho lưu trữ";
      case ModeSelection.report:
        return "Danh sách báo cáo/chặn";
      case ModeSelection.changePassword:
        return "Đổi mật khẩu";
      case ModeSelection.theme:
        return "Giao diện";
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: userServices.getUserById(context, _currentUser!.uid), 
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.hasError) {
                  return Icon(Icons.error, size: 100, color: AppColors.red);
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: AppColors.yellow));
                } else {
                  List<UserModel> userList = snapshot.data!;
                  return ListView.builder(
                    itemCount: userList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => UserWidget(
                      user: userList[index], 
                      onTap: () => Navigator.push(context, checkDeviceRoute(userInform(userList[index])))
                    ),
                  );
                }
              }
            ),
            SizedBox(height: 30),
            ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: [
                Selection(
                  onTap: () => onChooseMode(ModeSelection.about), 
                  icon: getIcon(ModeSelection.about), 
                  title: renderTitle(ModeSelection.about)
                ),
                Selection(
                  onTap: () => onChooseMode(ModeSelection.storage), 
                  icon: getIcon(ModeSelection.storage), 
                  title: renderTitle(ModeSelection.storage)
                ),
                Selection(
                  onTap: () => onChooseMode(ModeSelection.report), 
                  icon: getIcon(ModeSelection.report), 
                  title: renderTitle(ModeSelection.report)
                ),
                Selection(
                  onTap: () => onChooseMode(ModeSelection.changePassword), 
                  icon: getIcon(ModeSelection.changePassword), 
                  title: renderTitle(ModeSelection.changePassword)
                ),
                Selection(
                  onTap: () => onChooseMode(ModeSelection.theme),
                  icon: getIcon(ModeSelection.theme),
                  title: renderTitle(ModeSelection.theme),
                )
              ],
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.75,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                ),
                onPressed: () => ShowYesnoDialog.checkDeviceDialog(
                  context, 
                  title: "Đăng xuất", 
                  content: "Bạn có chắc chắn muốn đăng xuất khỏi hệ thống không?", 
                  onAcceptTap: () => onLogOut(), 
                  onCancelTap: () => Navigator.pop(context)
                ),
                child: Text("Đăng xuất",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}