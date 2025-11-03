import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/constants.dart';
import 'package:food_recipe_app/model/recent_view_model.dart';
import 'package:food_recipe_app/widget/other/message.dart';

import '../common/logger.dart';

class HistoryState extends ChangeNotifier{
  List<RecentViewModel> _viewProducts = [];
  List<RecentViewModel> get viewProducts => _viewProducts;

  HistoryState(){
    initData();
  }

  bool isExist(RecentViewModel data) => _viewProducts.contains(data);

  void toggle(RecentViewModel data) async{
    if (_viewProducts.contains(data)){
      _viewProducts.remove(data);
      await removeRecentView(data.viewId);
    } else {
      _viewProducts.add(data);
      await addRecentView(data);
    }
    notifyListeners();
  }

  Future<void> addRecentView(RecentViewModel view) async{
    try {
      await historyCollection.doc(view.viewId).set(view.toMap());
    } catch (e) {
      Message.showToast("Đã xảy ra lỗi");
      Logger.log(e);
      rethrow;
    }
  }

  Future<void> removeRecentView(String id) async {
    try {
      await historyCollection.doc(id).delete();
    } catch (e) {
      Message.showToast("Đã xảy ra lỗi");
      Logger.log(e);
      rethrow;
    }
  }

  Future<void> initData() async{
    try {
      final snapshot = await historyCollection.where("userId", isEqualTo: currentUser.uid).get();
      _viewProducts = snapshot.docs.map((e) => RecentViewModel.fromMap(e.data())).toList();
      notifyListeners();
    } catch (e) {
      Message.showToast("Đã xảy ra lỗi");
      Logger.log(e);
      rethrow;
    }
  }
}