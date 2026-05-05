import 'package:flutter/material.dart';
import 'package:food_recipe_app/model/food/category_model.dart';
import 'package:food_recipe_app/model/app/subscription_model.dart';

abstract class OtherDataRepo {
  Stream<List<CategoryModel>> getTags(BuildContext context);
  Stream<List<SubscriptionModel>> getSubscriptions(BuildContext context);
}