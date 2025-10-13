import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/services/authentication/auth_services.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../common/constants.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool isObscured1 = true, isObscured2 = true, isObscured3 = true;
  final oldPasswordController = TextEditingController();
  final newpasswordController = TextEditingController();
  final confirmController = TextEditingController();
  final _auth = AuthServices();
  final _currentUser = FirebaseAuth.instance.currentUser!;
  void handle() async{
    context.loaderOverlay.show();
    if (formKey.currentState!.validate()){
      if (newpasswordController.text != confirmController.text){
        context.loaderOverlay.hide();
        Message.showToast("Mật khẩu không trùng khớp");
        return;
      }
      formKey.currentState!.save();
      await _auth.changePassword(context,
        email: _currentUser.email!,
        oldPassword: oldPasswordController.text,
        newPassword: newpasswordController.text
      ).then((_){
        context.loaderOverlay.hide();
        Message.showScaffoldMessage(context, "Đổi mật khẩu thành công", AppColors.green);
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.green,
        title: Text("Đổi mật khẩu",
          style: TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
                    Text("Mật khẩu hiện tại",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: oldPasswordController,
                      obscureText: isObscured1,
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
                        hintText: "Nhập mật khẩu hiện tại",
                        hintStyle: TextStyle(
                          color: AppColors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.normal
                        ),
                        prefixIcon: Container(
                          width: 20,
                          height: 20,
                          alignment: Alignment.center,
                          child: Icon(Icons.lock, color: AppColors.black)
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isObscured1 ? Icons.visibility : Icons.visibility_off,
                            color: AppColors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              isObscured1 = !isObscured1;
                            });
                          },
                        )
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Vui lòng điền mật khẩu";
                        }
                        if (value.length < 6) {
                          return "Mật khẩu không dưới 6 ký tự";
                        }
                        return null;
                      },
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                    SizedBox(height: 20),
                    Text("Mật khẩu mới",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: newpasswordController,
                      obscureText: isObscured2,
                      cursorColor: AppColors.blue,
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w700
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.black)
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.red)
                        ),
                        hintText: "Nhập mật khẩu mới",
                        hintStyle: TextStyle(
                          color: AppColors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.normal
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.green)
                        ),
                        prefixIcon: Container(
                          width: 20,
                          height: 20,
                          alignment: Alignment.center,
                          child: Icon(Icons.lock, color: AppColors.black)
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isObscured2 ? Icons.visibility : Icons.visibility_off,
                            color: AppColors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              isObscured2 = !isObscured2;
                            });
                          },
                        )
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Vui lòng điền mật khẩu";
                        }
                        if (value.length < 6) {
                          return "Mật khẩu không dưới 6 ký tự";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    Text("Xác nhận mật khẩu",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: confirmController,
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w700
                      ),
                      obscureText: isObscured3,
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
                        hintText: "Nhập lại mật khẩu",
                        hintStyle: TextStyle(
                          color: AppColors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.normal
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.green)
                        ),
                        prefixIcon: Container(
                          width: 20,
                          height: 20,
                          alignment: Alignment.center,
                          child: Icon(Icons.lock, color: AppColors.black)
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isObscured3 ? Icons.visibility : Icons.visibility_off,
                            color: AppColors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              isObscured3 = !isObscured3;
                            });
                          },
                        )
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Vui lòng điền mật khẩu";
                        }
                        if (value.length < 6) {
                          return "Mật khẩu không dưới 6 ký tự";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.green,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(33))
                        ),
                        onPressed: handle,
                        child: Text("Xác nhận", 
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      )
    );
  }
}