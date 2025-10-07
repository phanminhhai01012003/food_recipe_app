import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class AuthRepo {
  Future<User?> loginWithAccount(BuildContext context, String email, String password);
  Future<User?> registerWithAccount(BuildContext context, String avatar, String name, String email, String password);
  Future<UserCredential?> loginWithGoogle(BuildContext context);
  Future<UserCredential?> loginWithFacebook(BuildContext context);
  Future<void> logOutFromAccount(BuildContext context);
  Future<void> logOutFromGoogle(BuildContext context);
  Future<void> logOutFromFacebook(BuildContext context);
  Future<void> forgotPassword(BuildContext context, String email);
  Future<void> changePassword(BuildContext context, {email, oldPassword, newPassword});
  Future<void> deleteAccount(BuildContext context);
}