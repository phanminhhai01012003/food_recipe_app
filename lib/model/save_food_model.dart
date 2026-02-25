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
  factory SaveFoodModel.fromMap(Map<String, dynamic> data) {
    return SaveFoodModel(
      saveId: data['saveId'] ?? "",
      userId: data['userId'] ?? "",
      isSaved: data['isSaved'] ?? false,
      foods: FoodModel.fromMap(data['foods'] ?? {}),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'saveId': saveId,
      'userId': userId,
      'isSaved': isSaved,
      'foods': foods.toMap(),
    };
  }
  SaveFoodModel.empty(){
    saveId = "";
    userId = "";
    isSaved = false;
    foods = FoodModel.empty();
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SaveFoodModel
      && runtimeType == other.runtimeType
      && other.saveId == saveId;
  }
  @override
  int get hashCode => saveId.hashCode;
}