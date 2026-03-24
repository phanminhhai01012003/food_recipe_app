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
  late bool isAI;
  late int views;
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
    required this.isAI,
    required this.views,
    required this.createdAt,
    required this.likes
  });
  factory FoodModel.fromMap(Map<String, dynamic> data){
    return FoodModel(
      foodId: data['foodId'] ?? "",
      image: data['image'] ?? "",
      title: data['title'] ?? "",
      description: data['description'] ?? "",
      userId: data['userId'] ?? "",
      userName: data['username'] ?? "",
      avatar: data['avatar'] ?? "",
      tag: data['tag'] ?? "",
      diet: data['diet'] ?? 0,
      duration: data['duration'] ?? "",
      ingredients: List<String>.from(data['ingredients'] ?? []),
      steps: List<String>.from(data['steps'] ?? []),
      isAI: data['isAI'] ?? false,
      views: data['views'] ?? 0,
      createdAt: DateTime.tryParse(data['createdAt'] ?? "") ?? DateTime.now(),
      likes: List<Map<String, dynamic>>.from(data['likes'] ?? []),
    );
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
      'isAI': isAI,
      'views': views,
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
      'isAI': isAI,
    };
  }
  FoodModel.empty(){
    foodId = "";
    image = "";
    title = "";
    description = "";
    userId = "";
    userName = "";
    avatar = "";
    tag = "";
    diet = 0;
    duration = "";
    ingredients = [];
    steps = [];
    views = 0;
    isAI = false;
    createdAt = DateTime.now();
    likes = [];
  }
  @override
  bool operator ==(Object other) => 
    identical(this, other) ||
      other is FoodModel && 
        runtimeType == other.runtimeType && 
        foodId == other.foodId;
  @override
  int get hashCode => foodId.hashCode;
}