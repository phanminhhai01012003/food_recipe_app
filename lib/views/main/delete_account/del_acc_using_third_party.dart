import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:food_recipe_app/common/configure/logger.dart';
import 'package:food_recipe_app/common/configure/routes.dart';
import 'package:food_recipe_app/common/constants/class_defined.dart';
import 'package:food_recipe_app/common/constants/firebase_constants.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loader_overlay/loader_overlay.dart';

Future<void> delAccUsingGoogle(BuildContext context) async{
  context.loaderOverlay.show();
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth?.idToken,
      accessToken: googleAuth?.accessToken
    );
    await currentUser.reauthenticateWithCredential(credential).then((value) async{
      await Future.wait([
        followServices.removeFollowUsers(context, value.user!.uid),
        userServices.deleteUser(context, value.user!.uid),
        authServices.deleteAccount(context)
      ]);
    });    
    context.loaderOverlay.hide();
    Message.showScaffoldMessage(context, "deleteOldAcc".tr(), AppColors.green);
    Navigator.pushAndRemoveUntil(context, checkDeviceRoute(loginPage), (route) => false);
  } catch (e) {
    Message.showScaffoldMessage(context, "longError".tr(), AppColors.red);
    Logger.log(e);
    context.loaderOverlay.hide();
    return;
  }
}

Future<void> delAccUsingFacebook(BuildContext context) async{
  context.loaderOverlay.show();
  try {
    final result = await FacebookAuth.instance.login(permissions: ['email', 'public_profile']);
    if (result.status == LoginStatus.success){
      final credential = FacebookAuthProvider.credential(result.accessToken!.tokenString);
      await currentUser.reauthenticateWithCredential(credential).then((value) async{
        await Future.wait([
          followServices.removeFollowUsers(context, value.user!.uid),
          userServices.deleteUser(context, value.user!.uid),
          authServices.deleteAccount(context)
        ]);
      });      
      context.loaderOverlay.hide();
      Message.showScaffoldMessage(context, "deleteOldAcc".tr(), AppColors.green);
      Navigator.pushAndRemoveUntil(context, checkDeviceRoute(loginPage), (route) => false);
    }else{
      context.loaderOverlay.hide();
      throw FirebaseAuthException(
        code: result.status.toString(),
        message: result.message,
      );      
    }    
  } catch (e) {
    Message.showScaffoldMessage(context, "longError".tr(), AppColors.red);
    Logger.log(e);
    context.loaderOverlay.hide();
    return;
  }
}