import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/constants.dart';
import 'package:food_recipe_app/common/logger.dart';
import 'package:food_recipe_app/common/routes.dart';
import 'package:food_recipe_app/services/authentication/auth_services.dart';
import 'package:food_recipe_app/services/firestore/user/user_services.dart';
import 'package:food_recipe_app/widget/dialog/show_yesno_dialog.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:loader_overlay/loader_overlay.dart';

class DeleteUserScreen extends StatefulWidget {
  const DeleteUserScreen({super.key});

  @override
  State<DeleteUserScreen> createState() => _DeleteUserScreenState();
}

class _DeleteUserScreenState extends State<DeleteUserScreen> {
  String? selectedOption;
  final _otherReport = TextEditingController();
  final userServices = UserServices();
  final authServices = AuthServices();
  final currentUser = FirebaseAuth.instance.currentUser!;
  void onDeleteAccount() async{
    context.loaderOverlay.show();
    await authServices.deleteAccount(context);
    await userServices.deleteUser(context, currentUser.uid);
    context.loaderOverlay.hide();
    Message.showScaffoldMessage(context, "Tài khoản cũ của bạn đã xóa. Hãy tạo tài khoản mới để tiếp tục sử dụng", AppColors.green);
    Navigator.pushAndRemoveUntil(context, checkDeviceRoute(loginPage), (route) => false);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        child: Column(
          children: [
            Text(
              "Bạn đang thực hiện xóa tài khoản khỏi hệ thống",
              style: TextStyle(
                color: AppColors.black,
                fontSize: 24,
                fontWeight: FontWeight.w800
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Hãy cho chúng tôi biết lý do bạn muốn xóa tài khoản cá nhân của mình (Trong trường hợp bạn muốn gửi yêu cầu duyệt đến quản trị viên)",
              style: TextStyle(
                color: AppColors.black,
                fontSize: 16,
                fontWeight: FontWeight.w800
              ),
            ),
            SizedBox(height: 20),
            ListView(
              children: List.generate(deleteUserList.length, (i) => radio(deleteUserList[i])),
            ),
            SizedBox(height: 5),
            TextField(
              maxLength: 500,
              controller: _otherReport,
              enabled: selectedOption == deleteUserList.last,
              decoration: InputDecoration(
                hintText: "Nhập nội dung",
                hintStyle: TextStyle(
                  color: selectedOption == deleteUserList.last ? AppColors.black : AppColors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.normal
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: selectedOption == deleteUserList.last ? AppColors.black : AppColors.grey)
                ),
                counterText: ""
              ),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.75,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red,
                  foregroundColor: AppColors.white
                ),
                onPressed: (){
                  ShowYesnoDialog.checkDeviceDialog(
                    context, 
                    title: "Xác nhận xóa", 
                    content: "Bạn có cảm thấy ổn khi xóa tài khoản chứ? Mọi dữ liệu sẽ mất hoàn toàn nếu bạn thực hiện", 
                    onAcceptTap: onDeleteAccount, 
                    onCancelTap: () => Navigator.pop(context)
                  );
                }, 
                child: Text(
                  "Xóa tài khoản",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal
                  ),
                )
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.75,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red,
                  foregroundColor: AppColors.white
                ),
                onPressed: () async{
                  context.loaderOverlay.show();
                  sendRequest();
                  context.loaderOverlay.hide();
                  Message.showScaffoldMessage(context, "Đã gửi yêu cầu", AppColors.green);
                  Navigator.pop(context);
                }, 
                child: Text(
                  "Gửi yêu cầu",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal
                  ),
                )
              ),
            )
          ],
        ),
      ),
    );
  }
  void sendRequest() async{
    try {
      await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .collection("delete_acc_request")
        .add({
          'reason': selectedOption == deleteUserList.last ? _otherReport.text : selectedOption
        });
    } catch (e) {
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi", AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }
  Widget radio(String title){
    return Radio<String>(
      value: title, 
      groupValue: selectedOption, 
      onChanged: (value) {
        setState(() {
          selectedOption = value;
        });
      }
    );
  }
}