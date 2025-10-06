import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/logger.dart';
import 'package:food_recipe_app/model/user_model.dart';
import 'package:food_recipe_app/services/firestore/user/user_repo.dart';
import '../../../widget/other/message.dart';

class UserServices extends UserRepo{

  final userCollection = FirebaseFirestore.instance.collection("users");

  @override
  Future<void> addUserWithAccount(BuildContext context, UserModel user) async{
    // TODO: implement addUserWithAccount
    try {
      await userCollection.doc(user.userId).set(user.toMap());
    } catch (e) {
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi", AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Future<void> addUserWithThirdParty(BuildContext context, UserModel user) async{
    // TODO: implement addUserWithThirdParty
    try {
      final userData = await userCollection.doc(user.userId).get();
      if (!userData.exists){
        await userCollection.doc(user.userId).set(user.toMap());
      } 
    } catch (e) {
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi", AppColors.red);
      Logger.log(e);
      rethrow;
    }   
  }

  @override
  Future<List<UserModel>> getUserById(BuildContext context, String id) async{
    // TODO: implement getCurrentUser
    try {
      return await userCollection
        .where("userId", isEqualTo: id)
        .get()
        .then((value) => value.docs.map((e) => UserModel.fromMap(e.data())).toList());
    } catch (e) {
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi", AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Future<void> updateUser(BuildContext context, UserModel user) async{
    // TODO: implement updateUser
    try {
      await userCollection.doc(user.userId).update(user.updateMap());
    } catch (e) {
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi", AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }
  
  @override
  Future<void> deleteUser(BuildContext context, String id) async{
    // TODO: implement deleteUser
    try {
      await userCollection.doc(id).delete();
    } catch (e) {
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi", AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

}