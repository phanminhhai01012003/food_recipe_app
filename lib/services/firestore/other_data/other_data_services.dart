import 'package:flutter/src/widgets/framework.dart';
import 'package:food_recipe_app/common/utils/logger.dart';
import 'package:food_recipe_app/common/constants/firebase_constants.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:food_recipe_app/model/food/category_model.dart';
import 'package:food_recipe_app/model/app/subscription_model.dart';
import 'package:food_recipe_app/services/firestore/other_data/other_data_repo.dart';
import 'package:food_recipe_app/widget/other/message.dart';

class OtherDataServices extends OtherDataRepo{
  @override
  Stream<List<SubscriptionModel>> getSubscriptions(BuildContext context) {
    // TODO: implement getSubscriptions
    try {
      return subCollection
        .snapshots()
        .map((event) => event.docs.map((e) => SubscriptionModel.fromMap(e.data())).toList());
    } catch (e) {
      Message.showScaffoldMessage(context, "shortError".tr(), AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

  @override
  Stream<List<CategoryModel>> getTags(BuildContext context) {
    // TODO: implement getTags
    try {
      return tagCollection
        .snapshots()
        .map((event) => event.docs.map((e) => CategoryModel.fromMap(e.data())).toList());
    } catch (e) {
      Message.showScaffoldMessage(context, "shortError".tr(), AppColors.red);
      Logger.log(e);
      rethrow;
    }
  }

}