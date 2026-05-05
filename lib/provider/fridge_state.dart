import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/constants/firebase_constants.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/utils/logger.dart';
import 'package:food_recipe_app/model/food/ingredient_model.dart';
import 'package:food_recipe_app/widget/other/message.dart';

class FridgeState extends ChangeNotifier{
  List<IngredientModel> _fridgeList = [];
  List<IngredientModel> get fridge => _fridgeList;

  FridgeState(){
    initData();
  }

  void addIngredientsToFridge(IngredientModel item) async{
    _fridgeList.add(item);
    await addProducts(item);
    notifyListeners();
  }

  void editIngredientsInFridge(IngredientModel item) async{
    int index = _fridgeList.indexWhere((element) => element.ingredientId == item.ingredientId);
    if(index != -1){
      _fridgeList[index] = item;
      await editProducts(item);
      notifyListeners();
    }
  }

  void removeIngredientsFromFridge(IngredientModel item) async{
    _fridgeList.remove(item);
    await removeProducts(item.ingredientId);
    notifyListeners();
  }

  Future<void> addProducts(IngredientModel item) async{
    try {
      await fridgeCollection.doc(item.ingredientId).set(item.toJson());
    } catch (e) {
      Message.showToast("shortError".tr());
      Logger.log(e);
      rethrow;
    }
  }

  Future<void> editProducts(IngredientModel item) async{
    try {
      await fridgeCollection.doc(item.ingredientId).update(item.updateJson());
    } catch (e) {
      Message.showToast("shortError".tr());
      Logger.log(e);
      rethrow;
    }
  }

  Future<void> removeProducts(String id) async {
    try {
      await fridgeCollection.doc(id).delete();
    } catch (e) {
      Message.showToast("shortError".tr());
      Logger.log(e);
      rethrow;
    }
  }

  Future<void> initData() async{
    try {
      final snapshot = await fridgeCollection.where("userId", isEqualTo: currentUser.uid).get();
      _fridgeList = snapshot.docs.map((data) => IngredientModel.fromJson(data.data())).toList();
      notifyListeners();
    } catch (e) {
      Message.showToast("shortError".tr());
      Logger.log(e);
      rethrow;
    }
  }

}