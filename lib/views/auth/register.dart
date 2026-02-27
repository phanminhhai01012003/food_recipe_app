import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/configure/routes.dart';
import 'package:food_recipe_app/common/constants/class_defined.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_assets.dart';
import 'package:food_recipe_app/model/follow_model.dart';
import 'package:food_recipe_app/model/user_model.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../common/style/app_colors.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isObscured1 = true, isObscured2 = true;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  void handle() async{
    context.loaderOverlay.show();
    if (formKey.currentState!.validate()) {
      if (passwordController.text != confirmController.text) {
        context.loaderOverlay.hide();
        Message.showToast("passwordInvalid2".tr());
        return;
      }
      formKey.currentState!.save();
      await authServices.registerWithAccount(context, 
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
            nickName: "",
            description: "",
            phone: phoneController.text.isEmpty ? "unknown" : phoneController.text,
            loginMethod: "Email and Password"
          );
          await userServices.addUserWithAccount(context, user);
          FollowModel follow = FollowModel(
            followId: user.userId, 
            followingUser: [], 
            followedUser: []
          );
          await followServices.addFollowUsers(context, follow, user.userId);
          context.loaderOverlay.hide();
          Message.showScaffoldMessage(context, "signUpSuccess".tr(), AppColors.green);
          Navigator.pushAndRemoveUntil(
            context, 
            checkDeviceRoute(mainPage), 
            (route) => false
          );
        } else {
          Message.showScaffoldMessage(context, "signUpFail".tr(), AppColors.red);
          context.loaderOverlay.hide();
          return;
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.green,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("signUp".tr(),
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
            constraints: BoxConstraints(maxHeight: 700),
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
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
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
                        hintText: "nameInput".tr(),
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
                          return "nameEmpty".tr();
                        }
                        if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                          return "nameInvalid".tr();
                        }
                        return null;
                      },
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
                        hintText: "phoneInput".tr(),
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
                        if (value == null || value.isEmpty){
                          return null;
                        }
                        if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(value)) {
                          return "phoneInvalid".tr();
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
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
                        hintText: "emailInput".tr(),
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
                          return "emailEmpty".tr();
                        }
                        if (!RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(value)) {
                          return "emailInvalid".tr();
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
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
                        hintText: "passwordInput".tr(),
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
                          return "passwordEmpty".tr();
                        }
                        if (value.length < 6) {
                          return "passwordInvalid1".tr();
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
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
                        hintText: "confirmPasswordInput".tr(),
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
                          return "passwordEmpty".tr();
                        }
                        if (value.length < 6) {
                          return "passwordInvalid1".tr();
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
                        child: Text("confirm".tr(), 
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
                        Text("haveAcc".tr(),
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
                          child: Text("loginBack".tr(),
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w400
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}