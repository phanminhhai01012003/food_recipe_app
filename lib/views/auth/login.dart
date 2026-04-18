import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/constants/class_defined.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_assets.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/common/configure/routes.dart';
import 'package:food_recipe_app/model/follow_model.dart';
import 'package:food_recipe_app/model/user_model.dart';
import 'package:food_recipe_app/services/notification/notification_service.dart';
import 'package:food_recipe_app/widget/bottom_sheet/change_language_modal.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:loader_overlay/loader_overlay.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isObscured = true;
  void handleAccount() async{
    context.loaderOverlay.show();
    await Future.delayed(Duration(seconds: 2));
    if (formKey.currentState!.validate()){
      formKey.currentState!.save();
      await authServices.loginWithAccount(context, emailController.text, passwordController.text).then((value) async{
        final token = await spServices.getStringValue("token");
        await NotificationService.saveTokenToFirestore(token ?? "");
        if (value != null){
          context.loaderOverlay.hide();
          Message.showScaffoldMessage(context, "signInSuccess".tr(), AppColors.green);
          Navigator.pushAndRemoveUntil(
            context, 
            checkDeviceRoute(mainPage), 
            (route) => false
          );
        } else {
          Message.showScaffoldMessage(context, "signInFail".tr(), AppColors.red);
          context.loaderOverlay.hide();
          return;
        }
      });
    }
  }
  void handleWithApple() async{
    context.loaderOverlay.show();
    await authServices.loginWithApple(context).then((value) async{
      final token = await spServices.getStringValue("token");
      if (value != null){
        UserModel user = UserModel(
          userId: value.user!.uid, 
          userName: value.user!.displayName ?? "", 
          avatar: value.user!.photoURL ?? "", 
          email: value.user!.email ?? "", 
          description: "",
          nickName: "",
          phone: value.user!.phoneNumber ?? "",
          loginMethod: "Apple",
          token: token ?? ""
        );
        await userServices.addUserWithThirdParty(context, user);
        FollowModel follow = FollowModel(
          followId: user.userId, 
          followingUser: [], 
          followedUser: []
        );
        await followServices.addFollowUsers(context, follow, user.userId);
        context.loaderOverlay.hide();
        Message.showScaffoldMessage(context, "signInSuccess".tr(), AppColors.green);
        Navigator.pushAndRemoveUntil(
          context, 
          checkDeviceRoute(mainPage), 
          (route) => false
        );
      } else {
        Message.showScaffoldMessage(context, "appleSignInFail".tr(), AppColors.red);
        context.loaderOverlay.hide();
        return;
      }
    });
  }
  void handleWithGoogle() async{
    context.loaderOverlay.show();
    await authServices.loginWithGoogle(context).then((value) async{
      final token = await spServices.getStringValue("token");
      if (value != null){
        UserModel user = UserModel(
          userId: value.user!.uid, 
          userName: value.user!.displayName ?? "", 
          avatar: value.user!.photoURL ?? "", 
          email: value.user!.email ?? "", 
          description: "",
          nickName: "",
          phone: value.user!.phoneNumber ?? "",
          loginMethod: "Google",
          token: token ?? "",
        );
        await userServices.addUserWithThirdParty(context, user);
        FollowModel follow = FollowModel(
          followId: user.userId, 
          followingUser: [], 
          followedUser: []
        );
        await followServices.addFollowUsers(context, follow, user.userId);
        context.loaderOverlay.hide();
        Message.showScaffoldMessage(context, "signInSuccess".tr(), AppColors.green);
        Navigator.pushAndRemoveUntil(
          context, 
          checkDeviceRoute(mainPage), 
          (route) => false
        );
      } else {
        Message.showScaffoldMessage(context, "googleSignInFail".tr(), AppColors.red);
        context.loaderOverlay.hide();
        return;
      }
    });
  }
  void handleWithFacebook() async{
    context.loaderOverlay.show();
    await authServices.loginWithFacebook(context).then((value) async{
      final token = await spServices.getStringValue("token");
      if (value != null){
        UserModel user = UserModel(
          userId: value.user!.uid, 
          userName: value.user!.displayName ?? "", 
          avatar: value.user!.photoURL ?? "", 
          email: value.user!.email ?? "", 
          description: "",
          nickName: "",
          phone: value.user!.phoneNumber ?? "",
          loginMethod: "Facebook",
          token: token ?? ""
        );
        await userServices.addUserWithThirdParty(context, user);
        FollowModel follow = FollowModel(
          followId: user.userId, 
          followingUser: [], 
          followedUser: []
        );
        await followServices.addFollowUsers(context, follow, user.userId);
        context.loaderOverlay.hide();
        Message.showScaffoldMessage(context, "signInSuccess".tr(), AppColors.green);
        Navigator.pushAndRemoveUntil(
          context, 
          checkDeviceRoute(mainPage), 
          (route) => false
        );
      } else {
        Message.showScaffoldMessage(context, "facebookSignInFail".tr(), AppColors.red);
        context.loaderOverlay.hide();
        return;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.green,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("login".tr(),
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
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: AppColors.blue,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
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
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w700
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
                    obscureText: isObscured,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w700
                    ),
                    cursorColor: AppColors.blue,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
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
                        return "passwordEmpty".tr();
                      } 
                      if (value.length < 6){
                        return "passwordInvalid1".tr();
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
                      child: Text("${"forgotPassword".tr()}?",
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
                      child: Text("login".tr(), 
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
                      Text("noAcc".tr(),
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
                        child: Text("signUp".tr(),
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
                  Text("otherMethod".tr(),
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
                      ),
                      Visibility(
                        visible: Platform.isIOS,
                        child: GestureDetector(
                          onTap: handleWithApple,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(fbImage,
                              fit: BoxFit.cover,
                              height: 50,
                              width: 50,
                            ),
                          )
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () async => await changeLanguageModal(context), 
                    child: Text(
                      "lang".tr(),
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.normal
                      ),
                    )
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}