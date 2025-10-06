import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/logger.dart';
import 'package:food_recipe_app/model/food_model.dart';
import 'package:food_recipe_app/services/firestore/food_recipe/food_repo.dart';
import 'package:food_recipe_app/widget/other/message.dart';

class FoodServices extends FoodRepo{

  final foodCollection = FirebaseFirestore.instance.collection("food_recipe");
  
  @override
  Future<void> addFood(BuildContext context, FoodModel food) async{
    // TODO: implement addFood
    try {
      await foodCollection.doc(food.foodId).set(food.toMap());
    } catch (e) {
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi", AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Future<void> deleteFood(BuildContext context, String id) async{
    // TODO: implement deleteFood
    try {
      await foodCollection.doc(id).delete();
    } catch (e) {
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi", AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Stream<List<FoodModel>> getFood(BuildContext context) {
    // TODO: implement getFood
    try {
      return foodCollection
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => FoodModel.fromMap(doc.data())).toList());
    } catch (e) {
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi", AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Stream<List<FoodModel>> getFoodByUser(BuildContext context, String id) {
    // TODO: implement getFoodByCurrentUser
    try {
      return foodCollection
        .where("userId", isEqualTo: id)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => FoodModel.fromMap(doc.data())).toList());
    } catch (e) {
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi", AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Stream<List<FoodModel>> getFoodByDate(BuildContext context) {
    // TODO: implement getFoodByDate
    try {
      return foodCollection
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => FoodModel.fromMap(doc.data())).toList());
    } catch (e) {
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi", AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Stream<List<FoodModel>> getFoodByTag(BuildContext context, String selectedTag) {
    // TODO: implement getFoodByTag
    try {
      return foodCollection
        .where("tag", isEqualTo: selectedTag)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => FoodModel.fromMap(doc.data())).toList());
    } catch (e) {
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi", AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Future<void> updateFood(BuildContext context, FoodModel food) async{
    // TODO: implement updateFood
    try {
      await foodCollection.doc(food.foodId).update(food.updateMap());
    } catch (e) {
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi", AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }
  
}