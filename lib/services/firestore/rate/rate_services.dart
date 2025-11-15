import 'package:flutter/src/widgets/framework.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/constants.dart';
import 'package:food_recipe_app/common/logger.dart';
import 'package:food_recipe_app/model/rating_model.dart';
import 'package:food_recipe_app/services/firestore/rate/rate_repo.dart';
import 'package:food_recipe_app/widget/other/message.dart';

class RateServices extends RateRepo{
  @override
  Future<void> addRating(BuildContext context, RatingModel rating) async{
    // TODO: implement addRating
    try {
      await rateCollection.doc(rating.ratingId).set(rating.toMap());
    } catch (e) {
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi", AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Future<void> deleteRating(BuildContext context, String id) async{
    // TODO: implement deleteRating
    try {
      await rateCollection.doc(id).delete();
    } catch (e) {
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi", AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Stream<List<RatingModel>> getRating(BuildContext context) {
    // TODO: implement getRating
    try {
      return rateCollection
        .snapshots()
        .map((value) => value.docs.map((e) => RatingModel.fromMap(e.data())).toList());
    } catch (e) {
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi", AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Future<void> updateRating(BuildContext context, RatingModel rating) async{
    // TODO: implement updateRating
    try {
      await rateCollection.doc(rating.ratingId).update(rating.updateMap());
    } catch (e) {
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi", AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }
  
  @override
  Stream<List<RatingModel>> getRatingByDate(BuildContext context, bool isDecending) {
    // TODO: implement getRatingByDate
    try {
      return rateCollection
        .orderBy("createdAt", descending: isDecending)
        .snapshots()
        .map((value) => value.docs.map((e) => RatingModel.fromMap(e.data())).toList());
    } catch (e) {
      Message.showScaffoldMessage(context, "Đã xảy ra lỗi", AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

}