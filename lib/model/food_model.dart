class FoodModel {
  late String foodId;
  late String image;
  late String title;
  late String description;
  late String userId;
  late String userName;
  late String avatar;
  late String tag;
  late int diet;
  late String duration;
  late List<String> ingredients;
  late List<String> steps;
  late DateTime createdAt;
  late List<Map<String, dynamic>> likes;
  FoodModel({
    required this.foodId,
    required this.image,
    required this.title,
    required this.description,
    required this.userId,
    required this.userName,
    required this.avatar,
    required this.tag,
    required this.diet,
    required this.duration,
    required this.ingredients,
    required this.steps,
    required this.createdAt,
    required this.likes
  });
  FoodModel.fromMap(Map<String, dynamic> data){
    foodId = data['foodId'] ?? "";
    title = data['title'] ?? "";
    image = data['image'] ?? "";
    description = data['description'] ?? "";
    userId = data['userId'] ?? "";
    userName = data['username'] ?? "";
    avatar = data['avatar'] ?? "";
    tag = data['tag'] ?? "";
    diet = data['diet'] ?? 0;
    duration = data['duration'] ?? "";
    ingredients = List<String>.from(data['ingredients'] ?? []);
    steps = List<String>.from(data['steps'] ?? []);
    createdAt = DateTime.tryParse(data['createdAt'] ?? "") ?? DateTime.now();
    likes = List<Map<String, dynamic>>.from(data['likes'] ?? []);
  }
  Map<String, dynamic> toMap() {
    return {
      'foodId': foodId,
      'title': title,
      'image': image,
      'description': description,
      'userId': userId,
      'username': userName,
      'avatar': avatar,
      'tag': tag,
      'diet': diet,
      'duration': duration,
      'ingredients': ingredients,
      'steps': steps,
      'createdAt': createdAt.toIso8601String(),
      'likes': likes,
    };
  }
  Map<String, dynamic> updateMap() {
    return {
      'image': image,
      'title': title,
      'description': description,
      'tag': tag,
      'diet': diet,
      'duration': duration,
      'ingredients': ingredients,
      'steps': steps,
    };
  }
}