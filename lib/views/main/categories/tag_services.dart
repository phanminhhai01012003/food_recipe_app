import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/model/category_model.dart';
import 'package:food_recipe_app/widget/other/message.dart';

import '../../../common/logger.dart';

class TagServices {
  final tagCollection = FirebaseFirestore.instance.collection("categories");
  Stream<List<CategoryModel>> getTags(BuildContext context) {
    try {
      return tagCollection
        .snapshots()
        .map((event) => event.docs.map((e) => CategoryModel.fromMap(e.data())).toList());
    } catch (e) {
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi", AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }
}