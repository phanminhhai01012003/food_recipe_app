class RatingModel {
  late String ratingId;
  late String userId;
  late String avatar;
  late String userName;
  late double ratingStar;
  late String content;
  late DateTime createdAt;
  late List<Map<String, dynamic>> likes;
  RatingModel({
    required this.ratingId,
    required this.userId,
    required this.avatar,
    required this.userName,
    required this.ratingStar,
    required this.content,
    required this.createdAt,
    required this.likes
  });
  factory RatingModel.fromMap(Map<String, dynamic> data){
    return RatingModel(
      ratingId: data['ratingId'] ?? "",
      userId: data['userId'] ?? "",
      avatar: data['avatar'] ?? "",
      userName: data['username'] ?? "",
      ratingStar: (data['ratingStar'] ?? 0).toDouble(),
      content: data['content'] ?? "",
      createdAt: DateTime.tryParse(data['createdAt'] ?? "") ?? DateTime.now(),
      likes: List<Map<String, dynamic>>.from(data['likes'] ?? []),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'ratingId': ratingId,
      'userId': userId,
      'avatar': avatar,
      'username': userName,
      'ratingStar': ratingStar,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'likes': likes
    };
  }
  Map<String, dynamic> updateMap() {
    return {
      'ratingStar': ratingStar,
      'content': content,
    };
  }
}