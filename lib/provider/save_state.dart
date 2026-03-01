import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/constants/firebase_constants.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/model/save_food_model.dart';
import 'package:food_recipe_app/widget/other/message.dart';

import '../common/configure/logger.dart';

class SaveState extends ChangeNotifier{
  List<SaveFoodModel> _foodProducts = [];
  List<SaveFoodModel> get foodProducts => _foodProducts;

  SaveState(){
    initData();
  }

  void toggleAdd(SaveFoodModel data) async{
    _foodProducts.add(data);
    await addSaveData(data);
    notifyListeners();
  }

  void toggleRemove(SaveFoodModel data) async{
    _foodProducts.removeWhere((item) => item.saveId == data.saveId);
    await removeSaveData(data.saveId);
    notifyListeners();
  }

  Future<void> addSaveData(SaveFoodModel save) async{
    try {
      await saveCollection.doc(save.saveId).set(save.toMap());
    } catch (e) {
      Message.showToast("shortError".tr());
      Logger.log(e);
      rethrow;
    }
  }

  Future<void> removeSaveData(String id) async {
    try {
      await saveCollection.doc(id).delete();
    } catch (e) {
      Message.showToast("shortError".tr());
      Logger.log(e);
      rethrow;
    }
  }

  Future<void> initData() async{
    try {
      final snapshot = await saveCollection.where("userId", isEqualTo: currentUser.uid).get();
      _foodProducts = snapshot.docs.map((e) => SaveFoodModel.fromMap(e.data())).toList();
      notifyListeners();
    } catch (e) {
      Message.showToast("shortError".tr());
      Logger.log(e);
      rethrow;
    }
  }
}