import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:food_recipe_app/common/utils/logger.dart';
import 'package:food_recipe_app/common/constants/firebase_constants.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/model/app/follow_model.dart';
import 'package:food_recipe_app/model/app/user_model.dart';
import 'package:food_recipe_app/services/firestore/follow/follow_repo.dart';
import 'package:food_recipe_app/widget/other/message.dart';

class FollowServices extends FollowRepo{
  @override
  Future<void> addFollowUsers(BuildContext context, FollowModel follow, String userId) async{
    // TODO: implement addFollowUsers
    try {
      await followCollection(userId).doc(userId).set(follow.toMap());
    } catch (e) {
      Message.showScaffoldMessage(context, "shortError".tr(), AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }
  
  @override
  Future<void> addFollowedUsers(BuildContext context, UserModel user, String userId) async{
    // TODO: implement addFollowedUsers
    try {
      await followCollection(userId).doc(userId).update({
        "followedUsers": FieldValue.arrayUnion([user.toMap()])
      });
    } catch (e) {
      Message.showScaffoldMessage(context, "shortError".tr(), AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Future<void> addFollowingUsers(BuildContext context, UserModel user, String userId) async{
    // TODO: implement addFollowingUsers
    try {
      await followCollection(userId).doc(userId).update({
        "followingUsers": FieldValue.arrayUnion([user.toMap()])
      });
    } catch (e) {
      Message.showScaffoldMessage(context, "shortError".tr(), AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Stream<List<FollowModel>> getFollowUsers(BuildContext context, String userId) {
    // TODO: implement getFollowedUsers
    try {
      return followCollection(userId)
        .snapshots()
        .map((value) => value.docs.map((e) => FollowModel.fromMap(e.data())).toList());
    } catch (e) {
      Message.showScaffoldMessage(context, "shortError".tr(), AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Future<void> removeFollowUsers(BuildContext context, String userId) async{
    // TODO: implement removeFollowUsers
    try {
      await followCollection(userId).doc(userId).delete();
    } catch (e) {
      Message.showScaffoldMessage(context, "shortError".tr(), AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Future<void> removeFollowedUsers(BuildContext context, UserModel user, String userId) async{
    // TODO: implement removeFollowedUsers
    try {
      await followCollection(userId).doc(userId).update({
        "followedUsers": FieldValue.arrayRemove([user.toMap()])
      });
    } catch (e) {
      Message.showScaffoldMessage(context, "shortError".tr(), AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Future<void> removeFollowingUsers(BuildContext context, UserModel user, String userId) async{
    // TODO: implement removeFollowingUsers
    try {
      await followCollection(userId).doc(userId).update({
        "followingUsers": FieldValue.arrayRemove([user.toMap()])
      });
    } catch (e) {
      Message.showScaffoldMessage(context, "shortError".tr(), AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

}