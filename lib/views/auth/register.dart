import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/routes.dart';
import 'package:food_recipe_app/model/user_model.dart';
import 'package:food_recipe_app/services/authentication/auth_services.dart';
import 'package:food_recipe_app/services/firestore/user/user_services.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../common/app_colors.dart';
import '../../common/constants.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _authServices = AuthServices();
  final _userDB = UserServices();
  bool isObscured1 = true, isObscured2 = true;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final phoneController = TextEditingController();
  void handle() async{
    context.loaderOverlay.show();
    if (formKey.currentState!.validate()) {
      if (passwordController.text != confirmController.text) {
        context.loaderOverlay.hide();
        Message.showToast("Mật khẩu không khớp");
        return;
      }
      formKey.currentState!.save();
      await _authServices.registerWithAccount(context, 
        userDefaultImage, 
        nameController.text, 
        emailController.text, 
        passwordController.text).then((value) async{
        if (value != null) {
          UserModel user = UserModel(
            userId: value.uid, 
            userName: nameController.text, 
            avatar: userDefaultImage, 
            email: emailController.text, 
            description: "",
            phone: phoneController.text.isEmpty ? "Không xác định" : phoneController.text,
            loginMethod: "Email and Password"
          );
          await _userDB.addUserWithAccount(context, user);
          context.loaderOverlay.hide();
          Message.showScaffoldMessage(context, "Tạo tài khoản thành công", AppColors.green);
          Navigator.pushAndRemoveUntil(
            context, 
            checkDeviceRoute(mainPage), 
            (route) => false
          );
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.green,
      body: SafeArea(
        child: Column(
          children: [
            Text("Tạo tài khoản mới",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.white,
                    offset: Offset(5, 5),
                    blurRadius: 5,
                    spreadRadius: 5,
                    blurStyle: BlurStyle.solid
                  )
                ]
              ),
              child: Expanded(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      Text("Số điện thoại",
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 10),
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
                      SizedBox(height: 20),
                      Text(
                        "Email",
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
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
                      Text("Mật khẩu",
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: passwordController,
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w700
                        ),
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
                          hintText: "Nhập mật khẩu",
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
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Xác nhận mật khẩu",
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: confirmController,
                        cursorColor: AppColors.blue,
                        obscureText: isObscured2,
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
                              isObscured2? Icons.visibility : Icons.visibility_off,
                              color: AppColors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                isObscured2 = !isObscured2;
                              });
                            },
                          )
                        ),
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w700
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
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          children: [
                            Text("Bạn đã có tài khoản? ",
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w400
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, checkDeviceRoute(loginPage));
                              },
                              child: Text("Về trang đăng nhập",
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
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