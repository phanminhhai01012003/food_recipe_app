import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/constants/class_defined.dart';
import 'package:food_recipe_app/common/constants/firebase_constants.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_assets.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/model/app/user_model.dart';
import 'package:food_recipe_app/views/main/user/circle_image_chosen.dart';
import 'package:food_recipe_app/widget/bottom_sheet/show_image_picker.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:loader_overlay/loader_overlay.dart';

class EditUser extends StatefulWidget {
  final UserModel user;
  const EditUser({super.key, required this.user});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final formKey = GlobalKey<FormState>();
  File? file;
  String fileUrl = "";
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final phoneController = TextEditingController();
  final nickNameController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fileUrl = widget.user.avatar;
    nameController.text = widget.user.userName;
    descriptionController.text = widget.user.description;
    phoneController.text = widget.user.phone == "unknown" ? "" : widget.user.phone;
    nickNameController.text = widget.user.nickName;
  }

  void update() async {
    context.loaderOverlay.show();
    await Future.delayed(Duration(seconds: 2));
    if (formKey.currentState!.validate()) {
      if (nickNameController.text == nameController.text) {
        context.loaderOverlay.hide();
        Message.showToast("nickNameInvalid2".tr());
        return;
      }
      formKey.currentState!.save();
      if (file != null) {
        fileUrl = await imageServices.uploadImage(
          context,
          file!,
          avatarFolder,
        );
      }
      UserModel user = UserModel(
        userId: widget.user.userId,
        userName: nameController.text,
        avatar: file == null && fileUrl.isEmpty ? userDefaultImage : fileUrl,
        email: widget.user.email,
        description: descriptionController.text,
        nickName: nickNameController.text,
        phone: phoneController.text.isEmpty ? "unknown" : phoneController.text,
        loginMethod: widget.user.loginMethod,
      );
      await currentUser.updateProfile(
        displayName: nameController.text,
        photoURL: file == null && fileUrl.isEmpty ? userDefaultImage : fileUrl,
      );
      await userServices.updateUser(context, user).then((_) {
        context.loaderOverlay.hide();
        Message.showScaffoldMessage(
          context,
          "updateFoodSuccess".tr(),
          AppColors.green,
        );
        Navigator.pop(context);
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
    phoneController.dispose();
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
              size: 20,
            ),
          ),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        title: Text(
          "editPersonalInformation".tr(),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: update,
            icon: Icon(Icons.check_circle, size: 30),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleImageChosen(
                  file: file, 
                  fileUrl: fileUrl,
                  onTap: () async {
                    final filePicked = await showImagePickerModal(context, false);
                    if (filePicked != null) {
                      setState(() {
                        file = filePicked;
                      });
                    }
                  },
                ),
              ),
              SizedBox(height: 20),
              Text(
                "name".tr(),
                style: TextStyle(
                  color: theme.colorScheme.secondary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: nameController,
                keyboardType: TextInputType.text,
                style: TextStyle(
                  color: theme.colorScheme.secondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
                cursorColor: AppColors.blue,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.colorScheme.secondary),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.red),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.green),
                  ),
                  hintText: "nameInput".tr(),
                  hintStyle: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                  prefixIcon: Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.person,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "nameEmpty".tr();
                  }
                  if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                    return "nameInvalid".tr();
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text(
                "nickName".tr(),
                style: TextStyle(
                  color: theme.colorScheme.secondary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: nickNameController,
                keyboardType: TextInputType.text,
                style: TextStyle(
                  color: theme.colorScheme.secondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
                cursorColor: AppColors.blue,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.colorScheme.secondary),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.red),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.green),
                  ),
                  hintText: "nickNameInput".tr(),
                  hintStyle: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                  prefixIcon: Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.person_pin,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null;
                  }
                  if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                    return "nickNameInvalid1".tr();
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text(
                "description2".tr(),
                style: TextStyle(
                  color: theme.colorScheme.secondary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: descriptionController,
                maxLength: 1000,
                maxLines: 5,
                minLines: 5,
                keyboardType: TextInputType.text,
                style: TextStyle(
                  color: theme.colorScheme.secondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
                cursorColor: AppColors.blue,
                decoration: InputDecoration(
                  counterText: "",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.colorScheme.secondary),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.red),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.green),
                  ),
                  hintText: "descriptionInput".tr(),
                  hintStyle: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                  prefixIcon: Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.description,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "phone".tr(),
                style: TextStyle(
                  color: theme.colorScheme.secondary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                style: TextStyle(
                  color: theme.colorScheme.secondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
                cursorColor: AppColors.blue,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.colorScheme.secondary),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.red),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.green),
                  ),
                  hintText: "phoneInput".tr(),
                  hintStyle: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                  prefixIcon: Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.phone,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null;
                  }
                  if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(value)) {
                    return "phoneInvalid".tr();
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${"email".tr()}:",
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: Expanded(
                      child: Text(
                        widget.user.email,
                        style: TextStyle(
                          color: theme.colorScheme.secondary,
                          fontSize: 16,
                          fontWeight: FontWeight.normal
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}