import 'package:flutter/material.dart';
import 'package:food_recipe_app/model/follow_model.dart';
import 'package:food_recipe_app/model/user_model.dart';

abstract class FollowRepo {
  Future<void> addFollowUsers(BuildContext context, FollowModel follow, String userId);
  Future<void> removeFollowUsers(BuildContext context, String userId);
  Stream<List<FollowModel>> getFollowUsers(BuildContext context, String userId);
  Future<void> addFollowingUsers(BuildContext context, UserModel user, String userId);
  Future<void> removeFollowingUsers(BuildContext context, UserModel user, String userId);  
  Future<void> addFollowedUsers(BuildContext context, UserModel user, String userId);
  Future<void> removeFollowedUsers(BuildContext context, UserModel user, String userId);
}