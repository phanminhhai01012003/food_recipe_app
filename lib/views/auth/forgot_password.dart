import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/constants.dart';
import 'package:food_recipe_app/services/authentication/auth_services.dart';
import 'package:food_recipe_app/widget/other/message.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();
  final _auth = AuthServices();
  void handle() async{
    await _auth.forgotPassword(context, emailController.text);
    emailController.clear();
    Message.showScaffoldMessage(context, "Đã gửi yêu cầu, vui lòng kiểm tra email", AppColors.green);
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.white,
        title: Text("Quên mật khẩu",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Nhập địa chỉ email của bạn để khôi phục",
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: emailController,
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
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.green)
                  ),
                  hintText: "Nhập email",
                  hintStyle: TextStyle(
                    color: AppColors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.normal
                  ),
                  prefixIcon: Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    child: Icon(Icons.email, color: AppColors.black)
                  )
                ),
                validator: (value) {
                  if (value == null || value.isEmpty){
                    return "Vui lòng điền email";
                  }
                  if (!RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(value)) {
                    return "Email không hợp lệ";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(33)),
                  backgroundColor: AppColors.green,
                  foregroundColor: AppColors.white
                ),
                onPressed: handle,
                child: Text("Gửi yêu cầu"),
              )
            ],
          ),
        ),
      ),
    );
  }
}