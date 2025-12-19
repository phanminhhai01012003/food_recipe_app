class NotificationModel {
  late String id;
  late String title;
  late String body;
  late String type;
  late String? from;
  late String? to;
  late Map<String, dynamic>? extraData;
  late bool isRead;
  late DateTime createdAt;
  late DateTime? readAt;
  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.from,
    this.to,
    this.extraData,
    required this.isRead,
    required this.createdAt,
    this.readAt
  });
  factory NotificationModel.fromMap(Map<String, dynamic> data) {
    return NotificationModel(
      id: data['id'] ?? "",
      title: data['title'] ?? "",
      body: data['body'] ?? "",
      type: data['type'] ?? "",
      from: data['from'] ?? "",
      to: data['to'] ?? "",
      extraData: data['extraData'] ?? {},
      isRead: data['isRead'] ?? false,
      createdAt: DateTime.tryParse(data['created_at'] ?? "") ?? DateTime.now(),
      readAt: DateTime.tryParse(data['read_at'] ?? "") ?? DateTime.now(),
    );
  }
  Map<String, dynamic> toAllUserMap() => {
    'id': id,
    'title': title,
    'body': body,
    'type': type,
    'isRead': isRead,
    'created_at': createdAt,
  };
  Map<String, dynamic> toSpecificUserMap() => {
    'id': id,
    'title': title,
    'body': body,
    'type': type,
    'from': from,
    'to': to,
    'extraData': extraData,
    'isRead': isRead,
    'created_at': createdAt
  };
}