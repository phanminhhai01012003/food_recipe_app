import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/constants/class_defined.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  void handle() async{
    context.loaderOverlay.show();
    await authServices.forgotPassword(context, emailController.text);
    emailController.clear();
    context.loaderOverlay.hide();
    Message.showScaffoldMessage(context, "forgotPasswordSuccess".tr(), AppColors.green);
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.white,
        title: Text("forgotPassword".tr(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("forgotPasswordTitle".tr(),
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold
                ),
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(33)),
                  backgroundColor: AppColors.green,
                  foregroundColor: AppColors.white
                ),
                onPressed: handle,
                child: Text("sendRequest".tr(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700
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