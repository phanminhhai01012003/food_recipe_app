import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/constants/class_defined.dart';
import 'package:food_recipe_app/common/constants/firebase_constants.dart';
import 'package:food_recipe_app/common/constants/list_constants.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
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
    if (selectedOption == "reportOther".tr()) {
      if (_otherReport.text.isEmpty) {
        Message.showToast("infoEmpty".tr());
        context.loaderOverlay.hide();
        return;
      }
    }
    await authServices.deleteAccount(context);
    await userServices.deleteUser(context, currentUser.uid);
    await followServices.removeFollowUsers(context, currentUser.uid);
    context.loaderOverlay.hide();
    Message.showScaffoldMessage(context, "deleteOldAcc".tr(), AppColors.green);
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
              "deleteUserTitle".tr(),
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 24,
                fontWeight: FontWeight.w800
              ),
            ),
            SizedBox(height: 20),
            Text(
              "deleteUserReason".tr(),
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
                  title: deleteUserList[i].tr(), 
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
              enabled: selectedOption == deleteUserList.last.tr(),
              decoration: InputDecoration(
                hintText: "contentInput".tr(),
                hintStyle: TextStyle(
                  color: selectedOption == deleteUserList.last.tr() ? theme.colorScheme.secondary : AppColors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.normal
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: selectedOption == deleteUserList.last.tr() ? theme.colorScheme.secondary : AppColors.grey)
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
                    title: "deleteUserConfirm".tr(), 
                    content: "deleteUserDesc".tr(), 
                    onAcceptTap: onDeleteAccount, 
                    onCancelTap: () => Navigator.pop(context)
                  );
                }, 
                child: Text(
                  "deleteAcc".tr(),
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
                      Message.showToast("infoEmpty".tr());
                      context.loaderOverlay.hide();
                      return;
                    }
                  }
                  sendRequest();
                  context.loaderOverlay.hide();
                  Message.showScaffoldMessage(context, "sendRequestSuccess".tr(), AppColors.green);
                  Navigator.pop(context);
                }, 
                child: Text(
                  "sendRequest".tr(),
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
                  "prev".tr(),
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
        'reason': selectedOption == deleteUserList.last.tr() ? _otherReport.text : selectedOption,
        'status': 0
      });
    } catch (e) {
      Message.showScaffoldMessage(context, "shortError".tr(), AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }
}