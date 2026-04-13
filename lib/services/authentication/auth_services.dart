import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:food_recipe_app/common/constants/firebase_constants.dart';
import 'package:food_recipe_app/common/configure/logger.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/services/authentication/auth_repo.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../common/style/app_colors.dart';

class AuthServices extends AuthRepo{

  @override
  Future<void> changePassword(BuildContext context, {
    required String email, 
    required String oldPassword, 
    required String newPassword
  }) async{
    // TODO: implement changePassword
    try {
      User? user = auth.currentUser;
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: oldPassword);
      await user?.reauthenticateWithCredential(credential).then((value) async{
        await value.user?.updatePassword(newPassword);
      });
    } catch (e) {
      Message.showScaffoldMessage(context, "changePasswordFail".tr(), AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Future<void> forgotPassword(BuildContext context, String email) async{
    // TODO: implement forgotPassword
    try{
      await auth.sendPasswordResetEmail(email: email);
    } catch(e){
      Message.showScaffoldMessage(context, "shortError".tr(), AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Future<void> logOutFromAccount(BuildContext context) async{
    // TODO: implement logOut
    try {
      await auth.signOut();
    } catch (e) {
      Message.showScaffoldMessage(context, "signOutFail".tr(), AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Future<User?> loginWithAccount(
    BuildContext context, 
    String email, 
    String password
  ) async{
    // TODO: implement loginWithAccount
    try {
      UserCredential credential = await auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = credential.user;
      return user;
    } catch (e) {
      Message.showScaffoldMessage(context, "signInFail".tr(), AppColors.red);
      Logger.log(e);
      return null;
    }
  }

  @override
  Future<UserCredential?> loginWithApple(BuildContext context) async{
    // TODO: implement loginWithApple
    try {
      AppleAuthProvider appleAuthProvider = AppleAuthProvider();
      appleAuthProvider.addScope('email');
      appleAuthProvider.addScope('name');
      return auth.signInWithProvider(appleAuthProvider);
    } catch (e) {
      Message.showScaffoldMessage(context, "appleSignInFail".tr(), AppColors.red);
      Logger.log(e);
      return null;
    }
  }

  @override
  Future<UserCredential?> loginWithFacebook(BuildContext context) async{
    // TODO: implement loginWithFacebook
    try {
      final result = await FacebookAuth.instance.login(permissions: ['email', 'public_profile']);
      if (result.status == LoginStatus.success) {
        final credential = FacebookAuthProvider.credential(result.accessToken!.tokenString);
        return await auth.signInWithCredential(credential);
      } else {
        throw FirebaseAuthException(
          code: result.status.toString(),
          message: result.message,
        );
      }
    } catch (e) {
      Message.showScaffoldMessage(context, "facebookSignInFail".tr(), AppColors.red);
      Logger.log(e);
      return null;
    }
  }

  @override
  Future<UserCredential?> loginWithGoogle(BuildContext context) async{
    // TODO: implement loginWithGoogle
    try {
      final google = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await google.signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth?.idToken,
        accessToken: googleAuth?.accessToken
      );
      return await auth.signInWithCredential(credential);
    } catch (e) {
      Message.showScaffoldMessage(context, "googleSignInFail".tr(), AppColors.red);
      Logger.log(e);
      return null;
    }
  }

  @override
  Future<User?> registerWithAccount(
    BuildContext context, 
    String avatar, 
    String name, 
    String email, 
    String password
  ) async{
    // TODO: implement registerWithAccount
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = credential.user;
      user?.updateProfile(displayName: name, photoURL: avatar);
      return user;
    } catch (e) {
      Message.showScaffoldMessage(context, "signUpFail".tr(), AppColors.red);
      Logger.log(e);
      return null;
    }
  }
  
  @override
  Future<void> deleteAccount(BuildContext context) async{
    // TODO: implement deleteUser
    try {
      User? user = auth.currentUser;
      if (user != null) {
        user.delete();
      } else {
        Message.showScaffoldMessage(context, "unknown".tr(), AppColors.red);
        return;
      }
    } catch (e) {
      Message.showScaffoldMessage(context, "longError".tr(), AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }
  
  @override
  Future<void> logOutFromFacebook(BuildContext context) async{
    // TODO: implement logOutFromFacebook
    try {
      await Future.wait([
        auth.signOut(),
        FacebookAuth.instance.logOut()
      ]);
    } catch (e) {
      Message.showScaffoldMessage(context, "signOutFail".tr(), AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }
  
  @override
  Future<void> logOutFromGoogle(BuildContext context) async{
    // TODO: implement logOutFromGoogle
    try {
      final google = GoogleSignIn();
      await Future.wait([
        google.signOut().then((value) => value!.clearAuthCache()),
        auth.signOut()
      ]);
    } catch (e) {
      Message.showScaffoldMessage(context, "signOutFail".tr(), AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }
  
}