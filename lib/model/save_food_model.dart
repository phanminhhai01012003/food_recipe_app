import 'package:food_recipe_app/model/food_model.dart';

class SaveFoodModel {
  late String saveId;
  late String userId;
  late bool isSaved;
  late FoodModel foods;
  SaveFoodModel({
    required this.saveId,
    required this.userId,
    required this.isSaved,
    required this.foods
  });
  SaveFoodModel.fromMap(Map<String, dynamic> data) {
    saveId = data['saveId'] ?? "";
    userId = data['userId'] ?? "";
    isSaved = data['isSaved'] ?? false;
    foods = FoodModel.fromMap(data['foods'] ?? {});
  }
  Map<String, dynamic> toMap() {
    return {
      'saveId': saveId,
      'userId': userId,
      'isSaved': isSaved,
      'foods': foods.toMap(),
    };
  }
}