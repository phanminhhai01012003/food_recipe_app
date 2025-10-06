import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/model/recent_view_model.dart';
import 'package:food_recipe_app/widget/other/message.dart';

import '../common/logger.dart';

class HistoryState extends ChangeNotifier{
  List<RecentViewModel> _viewProducts = [];
  List<RecentViewModel> get viewProducts => _viewProducts;

  final historyCollection = FirebaseFirestore.instance.collection("history");
  final _currentUser = FirebaseAuth.instance.currentUser;

  HistoryState(){
    initData();
  }

  void toggle(RecentViewModel data) async{
    if (_viewProducts.contains(data)){
      _viewProducts.remove(data);
      await removeSaveData(data.viewId);
    } else {
      _viewProducts.add(data);
      await addSaveData(data);
    }
    notifyListeners();
  }

  Future<void> addSaveData(RecentViewModel view) async{
    try {
      await historyCollection.doc(view.viewId).set(view.toMap());
    } catch (e) {
      Message.showToast("Đã xảy ra lỗi");
      Logger.log(e);
      rethrow;
    }
  }

  Future<void> removeSaveData(String id) async {
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
      final snapshot = await historyCollection.where("userId", isEqualTo: _currentUser!.uid).get();
      _viewProducts = snapshot.docs.map((e) => RecentViewModel.fromMap(e.data())).toList();
      notifyListeners();
    } catch (e) {
      Message.showToast("Đã xảy ra lỗi");
      Logger.log(e);
      rethrow;
    }
  }
}