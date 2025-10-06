class NotificationModel {
  late String id;
  late String title;
  late String body;
  late String type;
  late bool isRead;
  late DateTime createdAt;
  late DateTime? readAt;
  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.readAt
  });
  NotificationModel.fromMap(Map<String, dynamic> data) {
    id = data['id'] ?? "";
    title = data['title'] ?? "";
    body = data['body'] ?? "";
    type = data['type'] ?? "";
    isRead = data['isRead'] ?? false;
    createdAt = DateTime.tryParse(data['createdAt'] ?? "") ?? DateTime.now();
    readAt = DateTime.tryParse(data['readAt'] ?? "") ?? DateTime.now();
  }
  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'body': body,
    'type': type,
    'isRead': isRead,
    'created_at': createdAt,
    'readAt': readAt,
  };
}