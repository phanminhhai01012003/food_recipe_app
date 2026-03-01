import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/constants/firebase_constants.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/model/recent_view_model.dart';
import 'package:food_recipe_app/widget/other/message.dart';

import '../common/configure/logger.dart';

class HistoryState extends ChangeNotifier{
  List<RecentViewModel> _viewProducts = [];
  List<RecentViewModel> get viewProducts => _viewProducts;

  HistoryState(){
    initData();
  }

  void toggleAdd(RecentViewModel data) async{
    _viewProducts.add(data);
    await addRecentView(data);
    notifyListeners();
  }

  void toggleRemove(RecentViewModel data) async{
    _viewProducts.removeWhere((item) => item.viewId == data.viewId);
    await removeRecentView(data.viewId);
    notifyListeners();
  }

  Future<void> addRecentView(RecentViewModel view) async{
    try {
      await historyCollection.doc(view.viewId).set(view.toMap());
    } catch (e) {
      Message.showToast("shortError".tr());
      Logger.log(e);
      rethrow;
    }
  }

  Future<void> removeRecentView(String id) async {
    try {
      await historyCollection.doc(id).delete();
    } catch (e) {
      Message.showToast("shortError".tr());
      Logger.log(e);
      rethrow;
    }
  }

  Future<void> initData() async{
    try {
      final snapshot = await historyCollection
        .where("userId", isEqualTo: currentUser.uid)
        .orderBy("viewedAt", descending: true)
        .get();
      _viewProducts = snapshot.docs.map((e) => RecentViewModel.fromMap(e.data())).toList();
      notifyListeners();
    } catch (e) {
      Message.showToast("shortError".tr());
      Logger.log(e);
      rethrow;
    }
  }
}