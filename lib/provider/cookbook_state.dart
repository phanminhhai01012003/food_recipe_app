import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/model/cookbook_model.dart';
import 'package:food_recipe_app/model/food_model.dart';
import 'package:food_recipe_app/widget/other/message.dart';

import '../common/logger.dart';

class CookbookState extends ChangeNotifier{
  List<CookbookModel> _bookProducts = [];
  List<CookbookModel> get bookProducts => _bookProducts;

  final bookCollection = FirebaseFirestore.instance.collection("cookbook");
  final currentUser = FirebaseAuth.instance.currentUser;

  CookbookState(){
    initData();
  }

  void toggleFoodOnCookbook(CookbookModel cookbook, FoodModel food) async{
    if (cookbook.foodsList.contains(food)){
      await removeFoodFromCookBook(cookbook.cookbookId, food);
    } else {
      await addFoodToCookBook(cookbook.cookbookId, food);
    }
    notifyListeners();
  }

  bool isExist(CookbookModel cookbook, FoodModel food) => cookbook.foodsList.contains(food);

  Future<void> createCookbook(CookbookModel cookbook) async {
    try {
      await bookCollection.doc(cookbook.cookbookId).set(cookbook.toMap());
    } catch (e) {
      Message.showToast("Đã xảy ra lỗi");
      Logger.log(e);
      rethrow;
    }
  }

  Future<void> addFoodToCookBook(String id, FoodModel food) async{
    try {
      await bookCollection.doc(id).update({
        "foodsList": FieldValue.arrayUnion([food.toMap()])
      });
    } catch (e) {
      Message.showToast("Đã xảy ra lỗi");
      Logger.log(e);
      rethrow;
    }
  }

  Future<void> updateCookbook(CookbookModel cookbook) async{
    try {
      await bookCollection.doc(cookbook.cookbookId).update(cookbook.updateMap());
    } catch (e) {
      Message.showToast("Đã xảy ra lỗi");
      Logger.log(e);
      rethrow;
    }
  }

  Future<void> removeCookbook(String id) async{
    try {
      await bookCollection.doc(id).delete();
    } catch (e) {
      Message.showToast("Đã xảy ra lỗi");
      Logger.log(e);
      rethrow;
    }
  }

  Future<void> removeFoodFromCookBook(String id, FoodModel food) async {
    try {
      await bookCollection.doc(id).update({
        "foodsList": FieldValue.arrayRemove([food.toMap()])
      });
    } catch (e) {
      Message.showToast("Đã xảy ra lỗi");
      Logger.log(e);
      rethrow;
    }
  }

  Future<void> initData() async{
    try {
      final snapshot = await bookCollection.where("userId", isEqualTo: currentUser!.uid).get();
      _bookProducts = snapshot.docs.map((doc) => CookbookModel.fromMap(doc.data())).toList();
      notifyListeners();
    } catch (e) {
      Message.showToast("Đã xảy ra lỗi");
      Logger.log(e);
      rethrow;
    }
  }
}