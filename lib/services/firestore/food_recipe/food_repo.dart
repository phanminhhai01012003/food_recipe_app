import 'package:flutter/widgets.dart';
import 'package:food_recipe_app/model/food_model.dart';

abstract class FoodRepo {
  Future<void> addFood(BuildContext context, FoodModel food);
  Future<void> updateFood(BuildContext context, FoodModel food);
  Future<void> deleteFood(BuildContext context, String id);
  Stream<List<FoodModel>> getFood(BuildContext context);
  Stream<List<FoodModel>> getFoodByUser(BuildContext context, String id);
  Stream<List<FoodModel>> getFoodByTag(BuildContext context, String selectedTag);
  Stream<List<FoodModel>> getFoodByDate(BuildContext context, bool isDescending);
}