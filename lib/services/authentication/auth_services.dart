import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:food_recipe_app/common/logger.dart';
import 'package:food_recipe_app/services/authentication/auth_repo.dart';
import 'package:food_recipe_app/widget/other/message.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../common/app_colors.dart';

class AuthServices extends AuthRepo{

  final _auth = FirebaseAuth.instance;

  @override
  Future<void> changePassword(BuildContext context, {email, oldPassword, newPassword}) async{
    // TODO: implement changePassword
    try {
      User? user = _auth.currentUser;
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: oldPassword);
      await user?.reauthenticateWithCredential(credential);
      await user?.updatePassword(newPassword);
    } catch (e) {
      Message.showScaffoldMessage(context, "Đổi mật khẩu thất bại", AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Future<void> forgotPassword(BuildContext context, String email) async{
    // TODO: implement forgotPassword
    try{
      await _auth.sendPasswordResetEmail(email: email);
    } catch(e){
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi", AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Future<void> logOutFromAccount(BuildContext context) async{
    // TODO: implement logOut
    try {
      await _auth.signOut();
    } catch (e) {
      Message.showScaffoldMessage(context, "Lỗi khi thoát khỏi phiên đăng nhập", AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Future<User?> loginWithAccount(BuildContext context, String email, String password) async{
    // TODO: implement loginWithAccount
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = credential.user;
      return user;
    } catch (e) {
      Message.showScaffoldMessage(context, "Email hoặc mật khẩu không chính xác", AppColors.red);
      Logger.log(e);
      return null;
    }
  }

  @override
  Future<UserCredential?> loginWithFacebook(BuildContext context) async{
    // TODO: implement loginWithFacebook
    try {
      final result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );
      if (result.status == LoginStatus.success) {
        final credential = FacebookAuthProvider.credential(result.accessToken!.tokenString);
        return await _auth.signInWithCredential(credential);
      } else {
        throw FirebaseAuthException(
          code: result.status.toString(),
          message: result.message,
        );
      }
    } catch (e) {
      Message.showScaffoldMessage(context, "Lỗi đăng nhập Facebook", AppColors.red);
      Logger.log(e);
      return null;
    }
  }

  @override
  Future<UserCredential?> loginWithGoogle(BuildContext context) async{
    // TODO: implement loginWithGoogle
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth?.idToken,
        accessToken: googleAuth?.accessToken
      );
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      Message.showScaffoldMessage(context, "Lỗi đăng nhập Google", AppColors.red);
      Logger.log(e);
      return null;
    }
  }

  @override
  Future<User?> registerWithAccount(BuildContext context, String avatar, String name, String email, String password) async{
    // TODO: implement registerWithAccount
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = credential.user;
      user?.updateProfile(displayName: name, photoURL: avatar);
      return user;
    } catch (e) {
      Message.showScaffoldMessage(context, "Đăng ký tài khoản thất bại", AppColors.red);
      Logger.log(e);
      return null;
    }
  }
  
  @override
  Future<void> deleteAccount(BuildContext context) async{
    // TODO: implement deleteUser
    try {
      await _auth.currentUser!.delete();
    } catch (e) {
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi trong quá trình thực hiện", AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }
  
  @override
  Future<void> logOutFromFacebook(BuildContext context) async{
    // TODO: implement logOutFromFacebook
    try {
      await Future.wait([
        _auth.signOut(),
        FacebookAuth.instance.logOut()
      ]);
    } catch (e) {
      Message.showScaffoldMessage(context, "Lỗi khi thoát khỏi phiên đăng nhập", AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }
  
  @override
  Future<void> logOutFromGoogle(BuildContext context) async{
    // TODO: implement logOutFromGoogle
    try {
      await Future.wait([
        GoogleSignIn().signOut(),
        _auth.signOut()
      ]);
    } catch (e) {
      Message.showScaffoldMessage(context, "Lỗi khi thoát khỏi phiên đăng nhập", AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }
  
}