import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/constants/class_defined.dart';
import 'package:food_recipe_app/common/constants/firebase_constants.dart';
import 'package:food_recipe_app/common/constants/list_constants.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/common/configure/logger.dart';
import 'package:food_recipe_app/common/configure/routes.dart';
import 'package:food_recipe_app/widget/dialog/show_yesno_dialog.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:food_recipe_app/widget/other/radio_selection.dart';
import 'package:loader_overlay/loader_overlay.dart';

class DeleteUserScreen extends StatefulWidget {
  const DeleteUserScreen({super.key});

  @override
  State<DeleteUserScreen> createState() => _DeleteUserScreenState();
}

class _DeleteUserScreenState extends State<DeleteUserScreen> {
  String? selectedOption;
  final _otherReport = TextEditingController();
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
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        child: Column(
          children: [
            Text(
              "Bạn đang thực hiện xóa tài khoản khỏi hệ thống",
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 24,
                fontWeight: FontWeight.w800
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Hãy cho chúng tôi biết lý do bạn muốn xóa tài khoản cá nhân của mình (Trong trường hợp bạn muốn gửi yêu cầu duyệt đến quản trị viên)",
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 16,
                fontWeight: FontWeight.w800
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: List.generate(
                deleteUserList.length, 
                (i) => RadioSelection(
                  title: deleteUserList[i], 
                  selectedOption: selectedOption, 
                  onTap: (){
                    setState(() {
                      selectedOption = deleteUserList[i];
                    });
                  }, 
                  onChanged: (value){
                    setState(() {
                      selectedOption = value;
                    });
                  }
                )
              ),
            ),
            SizedBox(height: 5),
            TextField(
              maxLength: 500,
              controller: _otherReport,
              enabled: selectedOption == deleteUserList.last,
              decoration: InputDecoration(
                hintText: "Nhập nội dung",
                hintStyle: TextStyle(
                  color: selectedOption == deleteUserList.last ? theme.colorScheme.secondary : AppColors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.normal
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: selectedOption == deleteUserList.last ? theme.colorScheme.secondary : AppColors.grey)
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
                  backgroundColor: AppColors.green,
                  foregroundColor: AppColors.white
                ),
                onPressed: () async{
                  context.loaderOverlay.show();
                  if (selectedOption == deleteUserList.last) {
                    if (_otherReport.text.isEmpty){
                      Message.showToast("Vui lòng điền đầy đủ thông tin");
                      context.loaderOverlay.hide();
                      return;
                    }
                  }
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
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.75,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue,
                  foregroundColor: AppColors.white
                ),
                onPressed: () => Navigator.pop(context), 
                child: Text(
                  "Trang trước",
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
      await delAccReqCollection(currentUser.uid).add({
        'reason': selectedOption == deleteUserList.last ? _otherReport.text : selectedOption,
        'status': 0
      });
    } catch (e) {
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi", AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }
}