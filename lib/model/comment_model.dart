class CommentModel {
  late String commentId;
  late String userId;
  late String avatar;
  late String userName;
  late String content;
  late List<Map<String, dynamic>> likesList;
  late List<CommentModel> replies;
  late DateTime createdAt;
  CommentModel({
    required this.commentId,
    required this.userId,
    required this.avatar,
    required this.userName,
    required this.content,
    required this.likesList,
    required this.replies,
    required this.createdAt
  });
  CommentModel.fromMap(Map<String, dynamic> data) {
    commentId = data['commentId'] ?? "";
    userId = data['userId'] ?? "";
    avatar = data['avatar'] ?? "";
    userName = data['userName'] ?? "";
    content = data['content'] ?? "";
    likesList = List<Map<String, dynamic>>.from(data['likes'] ?? []);
    replies = (data['replies'] as List<dynamic>?)
        ?.map((e) => CommentModel.fromMap(e as Map<String, dynamic>))
        .toList() ?? [];
    createdAt = DateTime.tryParse(data['createdAt'] ?? "") ?? DateTime.now();
  }
  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'userId': userId,
      'avatar': avatar,
      'userName': userName,
      'content': content,
      'replies': replies.map((e) => e.toMap()).toList(),
      'likes': likesList,
      'createdAt': createdAt.toIso8601String(),
    };
  }
  Map<String, dynamic> updateMap() {
    return {
      'content': content
    };
  }
}