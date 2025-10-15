import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/constants.dart';
import 'package:food_recipe_app/model/user_model.dart';
import 'package:food_recipe_app/services/firestore/user/user_services.dart';
import 'package:food_recipe_app/services/image/image_service.dart';
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
  final currentUser = FirebaseAuth.instance.currentUser!;
  final userServices = UserServices();
  final imageServices = ImageService();
  File? image;
  String? imageUrl;
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final phoneController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      imageUrl = widget.user.avatar;
      nameController.text = widget.user.userName;
      descriptionController.text = widget.user.description;
      phoneController.text = widget.user.phone;
    });
  }
  void update() async{
    context.loaderOverlay.show();
    if (formKey.currentState!.validate()){
      formKey.currentState!.save();
      imageUrl = await imageServices.uploadImage(context, image!, avatarFolder);
      UserModel user = UserModel(
        userId: widget.user.userId, 
        userName: nameController.text, 
        avatar: imageUrl!, 
        email: widget.user.email, 
        description: descriptionController.text, 
        phone: phoneController.text.isEmpty ? "Không xác định" : phoneController.text, 
        loginMethod: widget.user.loginMethod
      );
      await currentUser.updateProfile(
        displayName: nameController.text,
        photoURL: imageUrl
      );
      await userServices.updateUser(context, user).then((_){
        context.loaderOverlay.hide();
        Message.showScaffoldMessage(context, "Cập nhật thành công", AppColors.green);
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
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.white,
        title: Text("Chỉnh sửa thông tin cá nhân",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: update, 
            icon: Icon(Icons.check_circle, size: 30)
          )
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
                child: image == null && imageUrl!.isEmpty
              ? InkWell(
                onTap: () => showImagePickerModal(context, image!),
                child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(color: Colors.black)
                    ),
                    child: Center(
                      child: Icon(
                        Icons.add_a_photo,
                        size: 50,
                        color: Colors.black,
                      ),
                    ),
                ),
              )
              : image != null ? InkWell(
                onTap: () => showImagePickerModal(context, image!),
                child: ClipRRect(
                  child: Image.file(image!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ) : InkWell(
                onTap: () => showImagePickerModal(context, image!),
                child: ClipRRect(
                  child: Image.network(imageUrl!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                ),
              ),
              SizedBox(height: 20),
                    Text("Tên đầy đủ",
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w700
                      ),
                      cursorColor: AppColors.blue,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.black)
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.red)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.green)
                        ),
                        hintText: "Nhập tên của bạn",
                        hintStyle: TextStyle(
                          color: AppColors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.normal
                        ),
                        prefixIcon: Container(
                          width: 20,
                          height: 20,
                          alignment: Alignment.center,
                          child: Icon(Icons.person, color: AppColors.black)
                        )
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty){
                          return "Vui lòng điền tên của bạn";
                        }
                        if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                          return "Tên không được chứa ký tự đặc biệt";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                Text("Giới thiệu bản thân",
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                    ),
              SizedBox(height: 10),
                    TextFormField(
                      controller: nameController,
                      maxLength: 1000,
                      maxLines: 5,
                      minLines: 5,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w700
                      ),
                      cursorColor: AppColors.blue,
                      decoration: InputDecoration(
                        counterText: "",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.black)
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.red)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.green)
                        ),
                        hintText: "Bạn là người như thế nào",
                        hintStyle: TextStyle(
                          color: AppColors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.normal
                        ),
                        prefixIcon: Container(
                          width: 20,
                          height: 20,
                          alignment: Alignment.center,
                          child: Icon(Icons.description, color: AppColors.black)
                        )
                      ),
                    ),
                    SizedBox(height: 20),
                TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w700
                      ),
                      cursorColor: AppColors.blue,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.black)
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.red)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.green)
                        ),
                        hintText: "Nhập sdt của bạn",
                        hintStyle: TextStyle(
                          color: AppColors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.normal
                        ),
                        prefixIcon: Container(
                          width: 20,
                          height: 20,
                          alignment: Alignment.center,
                          child: Icon(Icons.phone, color: AppColors.black)
                        )
                      ),
                      validator: (value) {
                        if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(value!)) {
                          return "Số điện thoại không hợp lệ";
                        }
                        return null;
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}