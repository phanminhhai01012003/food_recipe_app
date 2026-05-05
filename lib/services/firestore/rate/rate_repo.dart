import 'package:flutter/widgets.dart';
import 'package:food_recipe_app/model/community/rating_model.dart';

abstract class RateRepo {
  Future<void> addRating(BuildContext context, RatingModel rating);
  Future<void> updateRating(BuildContext context, RatingModel rating);
  Future<void> deleteRating(BuildContext context, String id);
  Stream<List<RatingModel>> getRating(BuildContext context);
  Stream<List<RatingModel>> getRatingByDate(BuildContext context, bool isDecending);
}