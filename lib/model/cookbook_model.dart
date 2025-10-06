import 'package:food_recipe_app/model/food_model.dart';

class CookbookModel {
  late String cookbookId;
  late String cookbookImage;
  late String cookbookName;
  late String description;
  late String userId;
  late DateTime createdAt;
  late List<FoodModel> foodsList;
  CookbookModel({
    required this.cookbookId,
    required this.cookbookImage,
    required this.cookbookName,
    required this.description,
    required this.userId,
    required this.createdAt,
    required this.foodsList
  });
  CookbookModel.fromMap(Map<String, dynamic> data){
    cookbookId = data['cookbookId'] ?? "";
    cookbookImage = data['cookbookImage'] ?? "";
    cookbookName = data['cookbookName'] ?? "";
    description = data['description'] ?? "";
    userId = data['userId'] ?? "";
    createdAt = DateTime.tryParse(data['createdAt'] ?? "") ?? DateTime.now();
    foodsList = (data['foodsList'] as List<dynamic>?)
      ?.map((e) => FoodModel.fromMap(e as Map<String, dynamic>))
      .toList() ?? [];
  }
  Map<String, dynamic> toMap(){
    return {
      'cookbookId': cookbookId,
      'cookbookImage': cookbookImage,
      'cookbookName': cookbookName,
      'description': description,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'foodsList': foodsList.map((e) => e.toMap()).toList(),
    };
  }
  Map<String, dynamic> updateMap(){
    return {
      'cookbookImage': cookbookImage,
      'cookbookName': cookbookName,
      'description': description,
      'foodsList': foodsList.map((e) => e.toMap()).toList(),
    };
  }
}