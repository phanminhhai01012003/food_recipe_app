import 'package:food_recipe_app/model/food_model.dart';

class RecentViewModel {
  late String viewId;
  late String userId;
  late bool isViewed;
  late DateTime viewedAt;
  late FoodModel foods;
  RecentViewModel({
    required this.viewId,
    required this.userId,
    required this.isViewed,
    required this.viewedAt,
    required this.foods
  });
  RecentViewModel.fromMap(Map<String, dynamic> data) {
    viewId = data['viewId'] ?? "";
    userId = data['userId'] ?? "";
    isViewed = data['isSaved'] ?? false;
    viewedAt = DateTime.tryParse(data['viewedAt'] ?? "") ?? DateTime.now();
    foods = FoodModel.fromMap(data['foods'] ?? {});
  }
  Map<String, dynamic> toMap() {
    return {
      'viewId': viewId,
      'userId': userId,
      'isViewed': isViewed,
      'viewedAt': viewedAt.toIso8601String(),
      'foods': foods.toMap(),
    };
  }
}