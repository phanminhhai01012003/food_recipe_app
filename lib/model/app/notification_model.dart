class NotificationModel {
  late String id;
  late String title;
  late String body;
  late String? androidImageUrl;
  late String? iosImageUrl;
  late String type;
  late String? from;
  late List<dynamic>? to;
  late Map<String, dynamic>? mainData;
  late Map<String, dynamic>? extraData;
  late bool isRead;
  late DateTime createdAt;
  late DateTime? readAt;
  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.androidImageUrl,
    this.iosImageUrl,
    required this.type,
    this.from,
    this.to,
    this.mainData,
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
      androidImageUrl: data['androidImage'] ?? "",
      iosImageUrl: data['iosImage'] ?? "",
      from: data['from'] ?? "",
      to: List.from(data['to'] ?? []),
      mainData: data['mainData'] ?? {},
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
    'androidImage': androidImageUrl,
    'iosImage': iosImageUrl,
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
    'mainData': mainData,
    'extraData': extraData,
    'isRead': isRead,
    'created_at': createdAt
  };
  NotificationModel.empty(){
    id = "";
    title = "";
    body = "";
    androidImageUrl = "";
    iosImageUrl = "";
    type = "";
    from = "";
    to = [];
    mainData = {};
    extraData = {};
    isRead = false;
    createdAt = DateTime.now();
    readAt = DateTime.now();
  }
}