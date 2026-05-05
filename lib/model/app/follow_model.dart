import 'package:food_recipe_app/model/app/user_model.dart';

class FollowModel {
  late String followId;
  late List<UserModel> followingUser;
  late List<UserModel> followedUser;
  FollowModel({
    required this.followId,
    required this.followingUser,
    required this.followedUser
  });
  factory FollowModel.fromMap(Map<String, dynamic> data){
    return FollowModel(
      followId: data['followId'] ?? "", 
      followingUser: List<UserModel>.from((data['followingUser'] as List).map((x) => UserModel.fromMap(x as Map<String, dynamic>))), 
      followedUser: List<UserModel>.from((data['followingUser'] as List).map((x) => UserModel.fromMap(x as Map<String, dynamic>)))
    );
  }
  Map<String, dynamic> toMap() => {
    "followId": followId,
    "followingUser": followingUser,
    "followedUser": followedUser
  };
}