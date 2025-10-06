import 'package:flutter/material.dart';
import 'package:food_recipe_app/model/user_model.dart';

abstract class UserRepo {
  Future<void> addUserWithAccount(BuildContext context, UserModel user);
  Future<void> addUserWithThirdParty(BuildContext context, UserModel user);
  Future<void> updateUser(BuildContext context, UserModel user);
  Future<void> deleteUser(BuildContext context, String id);
  Future<List<UserModel>> getUserById(BuildContext context, String id);
}