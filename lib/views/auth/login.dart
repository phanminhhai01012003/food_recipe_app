import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/constants.dart';
import 'package:food_recipe_app/common/routes.dart';
import 'package:food_recipe_app/model/user_model.dart';
import 'package:food_recipe_app/services/authentication/auth_services.dart';
import 'package:food_recipe_app/services/firestore/user/user_services.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:loader_overlay/loader_overlay.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _authServices = AuthServices();
  final _userDB = UserServices();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isObscured = true;
  void handleAccount() async{
    context.loaderOverlay.hide();
    if (formKey.currentState!.validate()){
      formKey.currentState!.save();
      await _authServices.loginWithAccount(context, emailController.text, passwordController.text).then((value) {
        if (value != null){
          context.loaderOverlay.hide();
          Message.showScaffoldMessage(context, "Đăng nhập thành công", AppColors.green);
          Navigator.pushAndRemoveUntil(
            context, 
            checkDeviceRoute(mainPage), 
            (route) => false
          );
        }
      });
    }
  }
  void handleWithGoogle() async{
    context.loaderOverlay.show();
    await _authServices.loginWithGoogle(context).then((value) async{
      if (value != null){
        UserModel user = UserModel(
          userId: value.user!.uid, 
          userName: value.user!.displayName!, 
          avatar: value.user!.photoURL!, 
          email: value.user!.email!, 
          description: "",
          phone: "",
          loginMethod: "Google"
        );
        await _userDB.addUserWithThirdParty(context, user);
        context.loaderOverlay.hide();
        Message.showScaffoldMessage(context, "", AppColors.green);
        Navigator.pushAndRemoveUntil(
          context, 
          checkDeviceRoute(mainPage), 
          (route) => false
        );
      }
    });
  }
  void handleWithFacebook() async{
    context.loaderOverlay.show();
    await _authServices.loginWithFacebook(context).then((value) async{
      if (value != null){
        UserModel user = UserModel(
          userId: value.user!.uid, 
          userName: value.user!.displayName!, 
          avatar: value.user!.photoURL!, 
          email: value.user!.email!, 
          description: "",
          phone: "",
          loginMethod: "Facebook"
        );
        await _userDB.addUserWithThirdParty(context, user);
        context.loaderOverlay.hide();
        Message.showScaffoldMessage(context, "", AppColors.green);
        Navigator.pushAndRemoveUntil(
          context, 
          checkDeviceRoute(mainPage), 
          (route) => false
        );
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.green,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Text("Đăng nhập",
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
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Email",
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
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
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w700
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
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Mật khẩu",
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: passwordController,
                        obscureText: isObscured,
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
                              isObscured ? Icons.visibility : Icons.visibility_off,
                              color: AppColors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                isObscured = !isObscured;
                              });
                            },
                          )
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Vui lòng điền mật khẩu";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(context, checkDeviceRoute(forgotPasswordPage));
                          },
                          child: Text("Quên mật khẩu?",
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.normal
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.green,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(33))
                          ),
                          onPressed: handleAccount,
                          child: Text("Đăng nhập", 
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Bạn chưa có tài khoản? ",
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w400
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, checkDeviceRoute(registerPage));
                            },
                            child: Text("Tạo tài khoản mới",
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w400
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      Text("Hoặc đăng nhập bằng:",
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: handleWithGoogle,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset(ggImage,
                                fit: BoxFit.cover,
                                height: 50,
                                width: 50,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: handleWithFacebook,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset(fbImage,
                                fit: BoxFit.cover,
                                height: 50,
                                width: 50,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}